//QtQuick
import QtQuick 2.0
//Ubuntu
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
//LOACAL
import QtRecorder 0.1
Tab {
    width: parent.width
    height: parent.height
    title: i18n.tr("About")
    property string  getAppPath: appPath
    page: Page {
        Column{
            anchors{
                horizontalCenter: parent.horizontalCenter
                top:  parent.top
                topMargin: units.gu(2)
            }
            Label{
                fontSize:  "x-large"
                text: "About Directions"
            }

            Label{
                fontSize:  "large"
                text: "ALL data is provided by Google and is copywrited by them"
            }

            Label{
                fontSize:  "large"
                text: "Qml Implamention done by Joseph Mills"
            }

            Label{
                fontSize:  "large"
                text: "ALL QML / C++  copywrited by the gplv3+"
            }

            Button{
                width:  parent.width
                height:  unis.dp(2)
                onClicked: console.log(recorder.outputLocation)
            }
            AudioRecorder{
                id: recorder
                outputLocation: getAppPath + "/output.flac"
                bitRate:  16000
                codec: "audio/FLAC"
                inputCard: "alsa:default"
                onErrorChanged: console.log("ERROR Changed \t " + errorString)
                Component.onCompleted: console.log(outputLocation)
            }
        }
    }
}
