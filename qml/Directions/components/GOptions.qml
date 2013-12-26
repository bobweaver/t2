//QT
import QtQuick 2.0

//Ubuntu
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem

Column {
    id: opt
    property bool open: false
   property bool miles: true
   property bool km: false
    property bool avoidTolls: false
    property bool avoidHighWays: false
    property bool multiLocations: true
    spacing:  12
    GOptionsSwitch{
        text: "Multi Locations"
        color: "white"
        checked: opt.multiLocations
    }
    GOptionsSwitch{
        text: "Avoid Tolls"
        color: "white"
        checked: opt.avoidTolls
    }
    GOptionsSwitch{
        text: "Avoid Highways"
        color: "white"
        checked: opt.avoidHighWays
    }

    Row{
        width: parent.width
        spacing: units.gu(2)
        GOptionsCheckBox{
            id: milesBox
            text: "Miles"
            color: "white"
            checked: opt.miles
            onClicked:  {
                if(opt.miles === true){
                    opt.miles= false
//                    console.log(checked )
                    opt.km = true
                }else{
                   opt.miles = true
                    opt.km= false
                }
            }
        }
        GOptionsCheckBox{
            id:kmBox
            text: "km"
            color: "white"
            checked: opt.km
            onClicked:{
                if(opt.km === true ){
                    opt.km = false
                    opt.miles = true
                }else{
                    opt.miles = false
                    opt.km = true
                }
            }
        }
    }
}
