//Qt
import QtQuick 2.0
//Ubuntu
import Ubuntu.Components 0.1
    Row{
            id:checkbox
            property string text
            property string color
            property bool checked: false
            signal clicked
        spacing: units.gu(3)
        Label{
            text: checkbox.text
            color: checkbox.color
        }
        CheckBox{
            checked: checkbox.checked
            onClicked:  checkbox.clicked()
        }
    }
