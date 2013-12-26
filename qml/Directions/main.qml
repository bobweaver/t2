//QT
import QtQuick 2.0
//Ubuntu
import Ubuntu.Components 0.1
//local
import "ui"
import"components"
import TextToSpeech 0.1
MainView {
    id: mainViewer
    objectName: "mainView"
    applicationName: "directions"
    automaticOrientation: true
    width: units.gu(40)
    height: units.gu(71)
    property string local: "en"

    property string forPreviews
//    property double destLat
//    property double destLng


    Home{
        anchors.fill: parent
    }

    Loader{
        id: directionsLoader
//         height: parent.height  - mainViewer.header.height
        source: ""
        anchors{
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }



        QGoogleSpeech{
            id: speechEngine
            text: ""
            language: local
        }
        Component.onCompleted: {
            //        Theme.name = "Ubuntu.Components.Themes.SuruGradient"
        }
    }
}
