#include "qgooglespeech.h"

QGoogleSpeech::QGoogleSpeech(QObject *parent) :
    QObject(parent)
{
    m_url = "http://translate.google.com/translate_tts?ie=UTF-8&tl=%1&q=%2";
    m_playlist = new QMediaPlaylist;
    m_player = new QMediaPlayer;
    QObject::connect(m_player, SIGNAL(error(QMediaPlayer::Error)),
                     this, SLOT(errorSlot()) );
    QObject::connect(m_player, SIGNAL(stateChanged(QMediaPlayer::State)),
                     this, SLOT(errorSlot()) );
}

QString QGoogleSpeech::language()const
{
   return  m_language;
}

void QGoogleSpeech::setLanguage(const QString &language)
{
    m_language = language;
}

QString  QGoogleSpeech::text()const
{
        return m_text;
}

void QGoogleSpeech::setText(const QString &text)
{
    m_text = text;
}

void QGoogleSpeech::speech()
{
    if (QMultimedia::Available == 0)  {
        QString i;
        m_text.replace(" ","+");
        m_playlist->addMedia(QUrl(m_url.arg(m_language).arg(m_text)));
        m_player->setPlaylist(m_playlist);
        m_player->play();
    } else {
        emit error();
    }
}
void QGoogleSpeech::errorSlot()
{
    emit error();
}
void QGoogleSpeech::state(QMediaPlayer::State state)
{
    if (state == QMediaPlayer::StoppedState)
        emit stopped();
}
