import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import "../components"
//Ubuntu
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1

Tab {
    title: i18n.tr("Get Directions")
    property string  loaderSource:{
        if (walk === true )
            return     Qt.resolvedUrl("../components/GWalkDirections.qml")
        if(bike === true )
            return   Qt.resolvedUrl("../components/GBikeDirections.qml")
        if(car === true )
            return    Qt.resolvedUrl("../components/GCarDirections.qml")
        if(bus === true )
            return  Qt.resolvedUrl("../components/GBusDirections.qml")
    }
    property bool bus: false
    property bool car: true
    property bool bike: false
    property bool walk: false

    //for adding binding to the Loader to use less code.

    property int routeInt
    property string modelSource

    page: Page {
        UbuntuShape{
            id: switcher
            width: parent.width
            Row{
                anchors.centerIn: parent
                Button{
                    text: "Drive"
                    id:forcar
                    onClicked:{
                        car = true
                        bus = false
                        bike = false
                        walk = false
                    }
                }
                Button{
                    id:forBus
                    text: "Bus"
                    onClicked:{
                        car = false
                        bus = true
                        bike = false
                        walk = false
                    }
                }

                Button{
                    id:forBike
                    text: "Bike"
                    onClicked:{
                        car = false
                        bus = false
                        bike = true
                        walk = false
                    }
                }
                Button{
                    id:forWalk
                    text:"Walk"
                    onClicked:{
                        car = false
                        bus = false
                        bike = false
                        walk = true
                    }
                }
            }
        }

        Loader{
            id: directionsLoader
            anchors{
                top: switcher.bottom
                bottom: parent.bottom
                right: parent.right
                left: parent.left
            }
            source: loaderSource
            Binding { target: directionsLoader.item; property: "route"; value: routeInt }
            Binding { target: directionsLoader.item; property: "source"; value: modelSource }
        }
    }
}
