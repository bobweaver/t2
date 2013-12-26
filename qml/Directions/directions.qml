//QT
import QtQuick 2.0
//Ubuntu
import Ubuntu.Components 0.1
//local
import "ui"
import"components"
import TextToSpeech 0.1
Page{
    objectName: "mainView"
    width: units.gu(40)
    height: units.gu(71)
    title: "Directions"
    property string local: "en"
    Tabs {
        id: tabs
        GetDirections {
            objectName: "Directions"
        }
        About {
            objectName: "About"
        }
    }
}
