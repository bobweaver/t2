//Qt
import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import QtLocation 5.0
//Ubuntu
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
// Locale

Item {
    id: rootDriveDir
    width: parent.width
    height: parent.height
    // propertys for settings
    property int starting: 0
    property bool multiLocation: true
    property int tempY: height
    Item{
        id:searchPage
        GReverseGeo{id:grev}
//        property string getLocal: grev.getLocation.address
        anchors.fill: parent
        Column{
            id: searchColumn
            width: parent.width
            height: parent.height
            anchors.centerIn:  searchPage
            spacing: units.gu(1)
            Label {
                text:  i18n.tr("Starting Location")
                color: "white"
                fontSize: "x-large"
            }

            TextField {
                id:staLoc
                placeholderText:  grev.getLocation.address
                text:  ""
                width: parent.width - units.gu(4)
            }
            ListItem.ThinDivider{}
            Label {
                text:  i18n.tr("Ending  Location")
                color: "white"
            }
            TextField {
                id:endLoc
                placeholderText: "End Location"
                width: parent.width - units.gu(4)
            }

            ListItem.ThinDivider{
                id: optionsRow
            }
            Row{
                Label{
                    id: routeOptionsDropDown
                    text: "Route Options"
                }
                Button {
                    iconSource: "/usr/share/unity/icons/dash_group_expand.png"
                    color: "transparent"
                    width: units.gu(1)
                    height: width
                    onClicked: {
                        if (options.open === true)
                        {
                            rotation = 0
                            options.open = false
                        }
                        else {
                            rotation = 90
                            options.open = true
                        }
                    }
                }
            }

            ListItem.ThinDivider{
                opacity: options.open ? 1:0
            }
            GOptions{
                id:options
                width: parent.width
                opacity: open ? 1:0
            }
            // Button to search and signal the Loader to Load the Results/
            ListItem.ThinDivider{
                id: go
            }
            Button{
                width: parent.width - units.gu(4)
                text: "Go"
                gradient: UbuntuColors.orangeGradient
                onClicked: {
                    // change this add binding and make new Loader page
                    firstModel.source =
                            "http://maps.googleapis.com/maps/api/directions/xml?origin="
                            + staLoc.text
                            + "&destination="
                            +endLoc.text
                            + "&sensor=false"
                            + "&alternatives="
                            +options.multiLocations
                    if(tempY !== 0 )
                        tempY = 0
                    else{
                        tempY = rootDriveDir.height
                    }
                }
            }
        }
    }
    Rectangle {
        id: firstModelDel
        width: parent.width
        height: parent.height
        color: "#221E1C"
        y: tempY
        ActivityIndicator {
            id: activity
            anchors.centerIn: parent
        }

        ListView{
            id: sd
            header: Label{ text: "Please Choice a Route" ;
           fontSize: "x-large" }
            width: firstModelDel.width
            height: firstModelDel.height
            model: firstModel
            spacing:  units.gu(2)
            delegate:
                UbuntuShape{
                width: firstModelDel.width
                height: firstModelDel.height
                color: "#88000000"
                UbuntuShape{
                    id:anchorTooME
                    width: parent.width / 2
                    height: parent.height
                    ActivityIndicator{
                        anchors.centerIn:  previewRouteMap
                        running: previewRouteMap.progression
                    }
                    MiniMap{
                        id: previewRouteMap
                        width: Math.round(parent.width /1.3)
                        height: Math.round(parent.height / 1.2)
                        anchors.centerIn: parent
                        pathLines: poly_lines
                        startingLat: starting_Lat
                        startingLng: starting_Lng
                        endingLat: ending_Lat
                        endingLng:  ending_Lng
                    }
                }
                UbuntuShape{
                    width: parent.width / 2
                    height: parent.height
                    anchors.left: anchorTooME.right
                    Column{
                        height: parent.height
                        width: parent.width
                        spacing: units.gu(5)
                        anchors.horizontalCenter: parent.horizontalCenter
                        ListItem.ThinDivider{}
                        Label{
                            text:"Summary: " + summary
                            fontSize: "large"// and in charge :P

                        }
                        ListItem.ThinDivider{}
                        Label{
                            text: duration
                            fontSize: "large"// and in charge :
                        }
                        ListItem.ThinDivider{}
                        Label{
                            text: distance
                            fontSize: "large"// and in charge :P
                        }
                        ListItem.ThinDivider{}
                        Button{
                            id: routeOption
                            text:"Go"
                            width: parent.width
                            onClicked: {
                                routeInt = model.index
                                modelSource = firstModel.source
                                directionsLoader.source = "GDrivingDirections.qml"
                            }
                        }
                        ListItem.ThinDivider{}
                    }
                }
            }

//        Component.onCompleted: {

//        }
        }

        XmlListModel{
            id: firstModel
            source: ""
            query: "/DirectionsResponse/route"
            XmlRole{name: "summary" ; query: "summary/string()"}
            XmlRole{name: "duration" ; query: "leg/duration/text/string()"}
            XmlRole{name: "distance" ; query: "leg/distance/text/string()"}
            XmlRole{name: "copyrights" ; query: "leg/copyrights/string()"}
            XmlRole{name: "poly_lines";query:"overview_polyline/points/string()"}
            XmlRole{name: "starting_Lat" ; query: "leg/start_location/lat/string()"}
            XmlRole{name: "starting_Lng" ; query: "leg/start_location/lng/string()"}
            XmlRole{name: "ending_Lat" ; query: "leg/end_location/lat/string()"}
            XmlRole{name: "ending_Lng" ; query: "leg/end_location/lng/string()"}
            XmlRole{name:"startingAddress"; query: "leg/start_address/string()"}
            onStatusChanged: {
                if(status === XmlListModel.Loading){
                    activity.running = true
                }
                if(status === XmlListModel.Ready){
                    activity.running = false
                }
                if(status === XmlListModel.Error){}
            }
        }
    }
}
