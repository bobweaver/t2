#ifndef  QTRECORDER_H
#define QTRECORDER_H
#include <QObject>
#include <QAudioRecorder>
#include <QtQml/qqmlparserstatus.h>
#include <QUrl>
#include <QMultimedia>
#include <QAbstractListModel>
#include <QtQml/qqml.h>
#include <qmediaplayer.h>

QT_BEGIN_NAMESPACE

class QtRecorder : public QObject , public QQmlParserStatus
{
    Q_OBJECT
    Q_PROPERTY( QString         codec                 READ codec                 WRITE setRecoderCodec     NOTIFY codecChanged            )
    Q_PROPERTY( int         sampleRate              READ sampleRate                 WRITE setSampleRate            NOTIFY sampleRateChanged    )
    Q_PROPERTY( int         channelCount                 READ channelCount                 WRITE setChannelCount     NOTIFY channelCountChanged            )
    Q_PROPERTY( int         bitRate              READ bitRate                 WRITE setBitRate           NOTIFY bitRateChanged      )
    Q_PROPERTY(QString   outputLocation READ outputLocation WRITE setOutputLocation NOTIFY outputLocationChanged )
    Q_PROPERTY(int duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(qreal volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(bool muted READ isMuted WRITE setMuted NOTIFY mutedChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY errorStringChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(Error error READ error NOTIFY errorChanged)
    Q_PROPERTY(RecordingState recordingState READ recordingState NOTIFY recordingStateChanged)
    Q_PROPERTY( QString inputCard READ inputCard WRITE setInputCard )

    Q_ENUMS(Status)
    Q_ENUMS(Error)
    Q_ENUMS(RecordingState)
    Q_INTERFACES(QQmlParserStatus)


public:
    Q_INVOKABLE void getInputs() ;
    Q_INVOKABLE void getSupportedAudioCodecs();
    enum Status
    {
        UnavailbeStatus = QAudioRecorder::UnavailableStatus,
        Unloaded       = QAudioRecorder::UnloadedStatus,
        Loading       = QAudioRecorder::LoadingStatus,
        Loaded        = QAudioRecorder::LoadedStatus,
        Starting       = QAudioRecorder::StartingStatus,
        Recording  = QAudioRecorder::RecordingStatus,
        Paused      = QAudioRecorder::PausedStatus,
        Encoding    = QAudioRecorder::FinalizingStatus
    };

    enum RecordingState
    {
        Stopped        = QAudioRecorder::StoppedState,
        Record  = QAudioRecorder::RecordingState,
        Pause    = QAudioRecorder::PausedState
    };

    enum Error
    {
        NoError = QAudioRecorder::NoError,
        ResourceError = QAudioRecorder::ResourceError,
        FormatError = QAudioRecorder::FormatError,
        OutOfSpace = QAudioRecorder::OutOfSpaceError
    };
    enum Quality
    {
        VeryLow = QMultimedia::VeryLowQuality,
        Low = QMultimedia::LowQuality,
        Normal = QMultimedia::NormalQuality,
        High = QMultimedia::HighQuality,
        VeryHigh = QMultimedia::VeryHighQuality
    };

    QtRecorder(QObject *parent = 0);
    ~QtRecorder();



    RecordingState recordingState() const;

    QString inputCard() const;
    void setInputCard(const QString &inputCard);


    QString codec() const;
    void setRecoderCodec(const QString &codec);

    int sampleRate() ;
    void setSampleRate(int &sampleRate);

    int channelCount();
    void setChannelCount(int &channelCount);

    int bitRate() ;
    void setBitRate( int &bitRate);

    QString outputLocation() const;
    void setOutputLocation(const QString &outputLocation);


    void classBegin();
    void componentComplete();



    int duration ();
    qreal volume() const;
    void setVolume(qreal &volume);
    bool isMuted() const;
    void setMuted(bool &muted);


    Status status() const;
    Error error() const;


    QMultimedia::EncodingQuality quality();
    QMultimedia::EncodingQuality setQuality(QMultimedia::EncodingQuality &quality);


    QString errorString() const;

public Q_SLOTS:
    void run();
    void pause();
    void stop();

Q_SIGNALS:
    void paused();
    void stopped();
    void running();
    void outputLocationChanged();
    void codecChanged();
    void sampleRateChanged();
    void channelCountChanged();
    void bitRateChanged();
    void statusChanged();
    void durationChanged();
    void inputChanged();
    void volumeChanged();
    void mutedChanged();
    void recordingStateChanged();
    void qualityChanged();
    void errorChanged();
    void errorStringChanged();
    void error(QtRecorder::Error error, const QString &errorString);

private Q_SLOTS:
    void _q_error(QMediaRecorder::Error);
    void _q_statusChanged();


private:
    void setAudioSettings();
    QAudioRecorder *m_recorder;
    QStringList  m_model;

    QString m_Codec;
    int m_SampleRate;
    int m_ChannelCount;
    int  m_BitRate;
    QString m_outputLocation;
    int m_duration;
    qreal m_volume;
//    QString m_input;
    bool m_muted;
    bool m_complete;
    QString m_errorString;
    QAudioRecorder::State m_recordingState;
    QAudioRecorder::Status m_status;
    QAudioRecorder::Error m_error;
    QMultimedia::EncodingQuality m_quality;
    QString m_Input;
};


QT_END_NAMESPACE

QML_DECLARE_TYPE(QT_PREPEND_NAMESPACE(QtRecorder))

#endif// QTRECORDER_H
