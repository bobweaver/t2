#include <QAudioEncoderSettings>
#include <QAudioProbe>
#include <QAudioRecorder>
#include <QDesktopServices>
#include <QUrl>
#include <QDebug>
#include <QtMultimedia>
#include <QQmlInfo>
#include "qtrecorder.h"

void QtRecorder::_q_error(QAudioRecorder::Error errorCode)
{
    m_error = errorCode;
    m_errorString = m_recorder->errorString();
    emit error(Error(errorCode), m_errorString);
    emit errorChanged();
}

QtRecorder::QtRecorder(QObject *parent)
    : QObject(parent)
    ,m_Codec("audio/FLAC")
    ,m_SampleRate(0)
    ,m_ChannelCount(0)
    ,m_BitRate(0)
    ,m_outputLocation("")
    , m_recorder(0)
    , m_volume(1.0)
    , m_muted(false)
    ,m_complete(false)
    , m_recordingState(QMediaRecorder::StoppedState)
    , m_status(QMediaRecorder::UnavailableStatus)
    , m_error(QMediaRecorder::FormatError)
    ,m_Input("")
{
}

QtRecorder::~QtRecorder()
{
    delete m_recorder;
}



QString QtRecorder::codec() const
{
    return m_Codec;
}
void QtRecorder::setRecoderCodec(const QString &codec)
{
    m_Codec = codec;
//    emit codecChanged();
}


QString QtRecorder::inputCard() const
{
    return m_Input;
}
void QtRecorder::setInputCard(const QString &inputCard)
{
    m_Input = inputCard;
}


int QtRecorder::sampleRate()
{
    return m_SampleRate;
}

void QtRecorder::setSampleRate( int &sampleRate)
{
    if (m_SampleRate == sampleRate)
        return;
    m_SampleRate = sampleRate;
    emit sampleRateChanged();
}


int QtRecorder::channelCount()
{
    return m_ChannelCount;
}
void QtRecorder::setChannelCount( int &channelCount)
{
    if (m_ChannelCount == channelCount)
        return;
    m_ChannelCount = channelCount;
    emit channelCountChanged();

}

int QtRecorder::bitRate()
{
    return m_BitRate;
}
void QtRecorder::setBitRate(int &bitRate)
{
    if (m_BitRate == bitRate)
        return;
    m_BitRate = bitRate;
    emit bitRateChanged();
}

QString QtRecorder::outputLocation() const
{
    return m_outputLocation;
}

void QtRecorder::setOutputLocation(const QString &outputLocation)
{
    if (m_outputLocation == outputLocation)
        return;
    m_outputLocation = outputLocation;
    emit outputLocationChanged();
}

//Make the Model for the cards
void QtRecorder::getInputs()
{
//    InputModel model;
    QStringList result;
    result = m_recorder->audioInputs();
        foreach (const QString &str, result) {
//        model.addInput(str);
        qDebug() << str;
        }
}

void QtRecorder::getSupportedAudioCodecs()
{
    QStringList result;
    result =m_recorder->supportedAudioCodecs();
        foreach (const QString &stp,  result)
        {
        qDebug() << stp;
        }
}

//  Quality

QMultimedia::EncodingQuality QtRecorder::quality()
{
    return QMultimedia::EncodingQuality(m_quality);
}

QMultimedia::EncodingQuality QtRecorder::setQuality(QMultimedia::EncodingQuality &quality)
{
    m_quality = quality;
    emit qualityChanged();
}












////////////////////ENUM


/*!
    \qmlproperty enumeration QtMultimedia::AudioRecorder::status

    This property holds the status of media loading. It can be one of:

    \list
    \li UnavailableStatus		The recorder is not available or not supported by connected media object.
    \li UnloadedStatus		The recorder is avilable but not loaded.
    \li LoadingStatus		The recorder is initializing.
    \li LoadedStatus		The recorder is initialized and ready to record media.
    \li StartingStatus		Recording is requested but not active yet.
    \li RecordingStatus		Recording is active.
    \li PausedStatus		Recording is paused.
    \liFinalizingStatus		Recording is stopped with media being finalized.
    \endlist
*/


//status
QtRecorder::Status QtRecorder::status() const
{
    return Status(m_status);
}

void QtRecorder::_q_statusChanged()
{
    const QMediaRecorder::Status oldStatus = m_status;
    const QMediaRecorder::State lastState = m_recordingState;
    const QMediaRecorder::State state = m_recorder->state();
    m_recordingState = state;
    m_status = m_recorder->status();
    if (m_status != oldStatus)
        emit statusChanged();
    if (lastState != state) {
        switch (state) {
        case QAudioRecorder::StoppedState:
            emit stopped();
            break;
        case QAudioRecorder::PausedState:
            emit paused();
            break;
        case QAudioRecorder::RecordingState:
            emit run();
            break;
        }
        emit statusChanged();
    }
}

// state

QtRecorder::RecordingState QtRecorder::recordingState() const
{
    return RecordingState(m_recordingState);
}


//errors
QtRecorder::Error QtRecorder::error() const
{
    return Error(m_error);
}




QString QtRecorder::errorString() const
{
    return m_errorString;
}







qreal QtRecorder::volume() const
{
    return !m_complete ? m_volume : qreal(m_recorder->volume()) / 100;
}

void QtRecorder::setVolume(qreal &volume)
{
    if (volume < 0 || volume > 1) {
        qmlInfo(this) << tr("volume should be between 0.0 and 1.0");
        return;
    }
    if (m_volume == volume)
        return;
    m_volume = volume;

    if (m_complete)
        m_recorder->setVolume(qRound(volume * 100));
}
















void QtRecorder::setAudioSettings()
{

    m_recorder->setAudioInput(m_Input);
    //    set up the settings
    QAudioEncoderSettings settings;
    settings.setCodec(m_Codec);
    settings.setSampleRate(m_SampleRate);
    settings.setChannelCount(m_ChannelCount);
    settings.setBitRate(m_BitRate);
    settings.setQuality(QMultimedia::NormalQuality);
    m_recorder->setEncodingSettings(settings);
    QString fileName = m_outputLocation;
    m_recorder->setOutputLocation(QUrl(fileName));




}


bool QtRecorder::isMuted() const
{
        return   m_muted;
}

void QtRecorder::setMuted(bool &muted)
{
    if (m_muted == muted)
        return;
    m_muted = muted;
    emit mutedChanged();

}

void QtRecorder::classBegin()
{
    m_recorder = new QAudioRecorder(this);

    connect(m_recorder, SIGNAL(stateChanged(QMediaRecorder::State)),
            this, SLOT(_q_statusChanged()));
    connect(m_recorder, SIGNAL(statusChanged(QMediaRecorder::Status)),
            this, SLOT(_q_statusChanged()));
//    connect(m_recorder, SIGNAL(volumeChanged(int)),
//            this, SIGNAL(volumeChanged()));
    connect(m_recorder, SIGNAL(error(QMediaRecorder::Error)),
            this, SLOT(_q_error(QMediaRecorder::Error)));
}

void QtRecorder::componentComplete()
{
    if (!qFuzzyCompare(m_volume, qreal(1.0)))
        m_recorder->setVolume(m_volume * 100);
    if (m_muted)
        m_recorder->setMuted(m_muted);
        m_recorder->setOutputLocation(m_outputLocation);

//    }
    m_complete = true;
}

void QtRecorder::run()
{
    setAudioSettings();
    if (m_recorder->state() == QMediaRecorder::StoppedState)
    {
    m_recorder->record();
    }
    else
    {
    m_recorder->stop();
    }
}

void QtRecorder::stop()
{
//    if (m_recorder->state() == QMediaRecorder::RecordingState) {
    m_recorder->stop();
//    else{
//    m_recorder->state() == QMediaRecorder::FinalizingStatus
//    m_recorder->stop();
//    }
}
void QtRecorder::pause()
{
    m_recorder->pause();
}
