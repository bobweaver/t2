#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include "qgooglespeech.h"
#include "qtrecorder.h"
#include <QtQuick>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<QGoogleSpeech>("TextToSpeech", 0,1,"QGoogleSpeech");
    qmlRegisterType<QtRecorder>("QtRecorder", 0,1,"AudioRecorder");


    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/Directions/main.qml"));


    QUrl appPath(QString("%1").arg(app.applicationDirPath()));
    viewer.rootContext()->setContextProperty("appPath", appPath);

    QUrl appQmlPath(QString("%1").arg(app.applicationDirPath())+(QString("/qml/Mythbuntu-QML/")));
    viewer.rootContext()->setContextProperty("appQmlPath", appQmlPath);

    QUrl appThemePath(QString("%1").arg(app.applicationDirPath())+(QString("/qml/Mythbuntu-QML/themes/")));
    viewer.rootContext()->setContextProperty("appThemePath", appThemePath);


    QUrl imagePath;
    const QStringList picturesLocation = QStandardPaths::standardLocations(QStandardPaths::PicturesLocation);
    if (picturesLocation.isEmpty())
        imagePath = appPath.resolved(QUrl("images"));
    else
        imagePath = QString("%1").arg(picturesLocation.first());
    viewer.rootContext()->setContextProperty("imagePath", imagePath);

    QUrl videoPath;
    const QStringList moviesLocation = QStandardPaths::standardLocations(QStandardPaths::MoviesLocation);
    if (moviesLocation.isEmpty())
        videoPath = appPath.resolved(QUrl("./"));
    else
        videoPath = QString("%1").arg(moviesLocation.first());
    viewer.rootContext()->setContextProperty("videoPath", videoPath);

    QUrl homePath;
    const QStringList homesLocation = QStandardPaths::standardLocations(QStandardPaths::HomeLocation);
    if (homesLocation.isEmpty())
        homePath = appPath.resolved(QUrl("/"));
    else
        homePath = QString("%1").arg(homesLocation.first());
    viewer.rootContext()->setContextProperty("homePath", homePath);

    QUrl desktopPath;
    const QStringList desktopsLocation = QStandardPaths::standardLocations(QStandardPaths::DesktopLocation);
    if (desktopsLocation.isEmpty())
        desktopPath = appPath.resolved(QUrl("/"));
    else
        desktopPath = QString("%1").arg(desktopsLocation.first());
    viewer.rootContext()->setContextProperty("desktopPath", desktopPath);

    QUrl docPath;
    const QStringList docsLocation = QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation);
    if (docsLocation.isEmpty())
        docPath = appPath.resolved(QUrl("/"));
    else
        docPath = QString("%1").arg(docsLocation.first());
    viewer.rootContext()->setContextProperty("docPath", docPath);

    QUrl applicationPath;
    const QStringList applicationsLocation = QStandardPaths::standardLocations(QStandardPaths::ApplicationsLocation);
    if (applicationsLocation.isEmpty())
        applicationPath = appPath.resolved(QUrl("/"));
    else
        applicationPath = QString("file:///%1").arg(applicationsLocation.first());
    viewer.rootContext()->setContextProperty("applicationPath", applicationPath);







    viewer.showExpanded();


    return app.exec();
}
