//QT
import QtQuick 2.0
//Ubuntu
import Ubuntu.Components 0.1
UbuntuShape{
    id:rootStep
    width: parent.width
    height: parent.height
    color: "#88000000"
    property string text
    property string duration
    property string distance
    property string icon
    signal clicked
     Button{
        width: parent.width
        height: parent.height
        onClicked: rootStep.clicked()
        Image {
            id: dirImage
            width: 48
            height: width
            source: "../graphics/"+icon+".png"
            anchors{
                left: parent.left
                leftMargin: units.gu(1)
                verticalCenter:  parent.verticalCenter
            }
        }
        Label{
            fontSize:"x-large"
            text: rootStep.icon
            color: "white"
            anchors{
                top: parent.top
                left:  dirImage.right
            }
        }
        Label{
            text: rootStep.text
            anchors.centerIn: parent
            width: parent.width / 2
            wrapMode: Text.WordWrap
        }
        Label{
            //fix to update on gps
            text: "distance  " + distance
            color: "white"
            anchors{
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
