//Qt
import QtQuick 2.0
//Ubuntu
import Ubuntu.Components 0.1
UbuntuShape{
    id: switcher
    width: parent.width
    height:sw.height
    property string text
    property string color
    property bool checked: false
    signal clicked
    Label{
        text: switcher.text
        color: switcher.color
        anchors{left: parent.left}
    }
    Switch{
        id:sw
        checked: switcher.checked
        anchors{right: parent.right}
        onClicked: {
            switcher.clicked()
        }
    }
}
