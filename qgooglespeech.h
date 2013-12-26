#ifndef QGOOGLESPEECH_H
#define QGOOGLESPEECH_H

#include <QString>
#include <QObject>
#include <QtMultimedia>
#include <QQuickItem>


class  QGoogleSpeech: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString language READ language WRITE setlanguage NOTIFY languageChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    explicit QGoogleSpeech(QObject *parent = 0);

    QString  language()const;
    void setLanguage(const QString &language);

    QString  text()const;
    void setText(const QString &text);


    Q_INVOKABLE void speech();

signals:
    void stopped();
    void error();
    void languageChanged();
    void textChanged();
private slots:
    void errorSlot();
    void state(QMediaPlayer::State state);
private:
    QString m_language;
    QMediaPlaylist *m_playlist;
    QMediaPlayer *m_player;
    QString m_url;
    QString m_text;

};

#endif // QGOOGLESPEECH_H
