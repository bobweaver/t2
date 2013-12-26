//QT
import QtQuick 2.0
//import QtWebKit 3.0
import  QtQuick.XmlListModel 2.0
//Ubuntu
import Ubuntu.Components 0.1
//local
import"../components"
Page{
    id: homeRoot
    width: units.gu(40)
    height: units.gu(71)
    property int zoomScale: 14
    GetLocation{id:gloc}
    tools: ToolbarItems{
        ToolbarButton{
            action: Action {
                text:  "zoom in"
                onTriggered:{
                    var sN = homeRoot.zoomScale;
                    var q = sN
                    if (searchBar.singleChecker === false){
                        map.source =  "http://maps.googleapis.com/maps/api/staticmap"
                                + "?center="
                                + gloc.getLocation.lat
                                +","
                                +  gloc.getLocation.lng
                                + "&zoom="
                                + q++
                                +"&size="
                                +  homeRoot.width
                                +"x"
                                +homeRoot.height
                                +"&markers=color:blue%7Csize:mid%7C"
                                + gloc.getLocation.lat +"," +  gloc.getLocation.lng
                                +"&sensor=false"
                        homeRoot.zoomScale = q++;
                        //                        console.log(map.source)
                    }
                    else {
                        map.source =  "http://maps.googleapis.com/maps/api/staticmap"
                                + "?center="
                                + searchBar.singleLat
                                +","
                                +  searchBar.singleLng
                                + "&zoom="
                                + q++
                                +"&size="
                                +  homeRoot.width
                                +"x"
                                +homeRoot.height
                                +"&markers=color:blue%7Csize:mid%7C"
                                + gloc.getLocation.lat +"," +  gloc.getLocation.lng
                                + "&markers=color:red%7Csize:mid%7C"
                                + searchBar.singleLat +"," +  searchBar.singleLng
                                +"&sensor=false"
                        homeRoot.zoomScale = q++;
                    }
                }

            }
        }
        ToolbarButton{
            action: Action {
                text:  "zoom out"
                onTriggered:{
                    var sN = homeRoot.zoomScale;
                    var q = sN
                    if (searchBar.singleChecker === false ){
                        map.source =  "http://maps.googleapis.com/maps/api/staticmap"
                                + "?center="
                                + gloc.getLocation.lat
                                +","
                                +  gloc.getLocation.lng
                                + "&zoom="
                                + q--
                                +"&size="
                                +  homeRoot.width
                                +"x"
                                +homeRoot.height
                                +"&markers=color:blue%7Csize:mid%7C"
                                + gloc.getLocation.lat +"," +  gloc.getLocation.lng
                                +"&sensor=false"
                        homeRoot.zoomScale = q--;
                        //                        console.log(map.source)
                    }else{
                        map.source =  "http://maps.googleapis.com/maps/api/staticmap"
                                + "?center="
                                + searchBar.singleLat
                                +","
                                +  searchBar.singleLng
                                + "&zoom="
                                + q--
                                +"&size="
                                +  homeRoot.width
                                +"x"
                                +homeRoot.height
                                +"&markers=color:blue%7Csize:mid%7C"
                                + gloc.getLocation.lat +"," +  gloc.getLocation.lng
                                + "&markers=color:red%7Csize:mid%7C"
                                + searchBar.singleLat +"," +  searchBar.singleLng
                                +"&sensor=false"
                        homeRoot.zoomScale = q--;
                    }

                }
            }
        }
    }

    Flickable{
        contentWidth: parent.width * 2
        contentHeight:  parent.height * 2
        contentX: parent.width
        contentY:  parent.height
        width: parent.width
        height: parent.width
        interactive: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        Image{
            id: map
            width: parent.width
            height: parent.height
            asynchronous: true
            smooth: true
            source:{
                var t =  "http://maps.googleapis.com/maps/api/staticmap"
                        + "?center="
                        + gloc.getLocation.lat
                        +","
                        +  gloc.getLocation.lng
                        + "&zoom="
                        + 14
                        +"&size="
                        + width
                        +"x"
                        +height
                        +"&markers=color:blue%7Csize:mid%7C"
                        + gloc.getLocation.lat +"," +  gloc.getLocation.lng
                        +"&sensor=false"
                t
            }
            onXChanged:  smooth.restart()
        }
    }
    NumberAnimation{id: smooth;target: map; property: "opacity" ;duration:  200 }
    SearchBar{
        id: searchBar
        anchors.top: parent.top
        anchors.topMargin: units.gu(3)
        onClicked: {
            //            console.log("LOOK AT ME "+singleLat+ singleLng + singleName)
            var singleMapView  =   "http://maps.googleapis.com/maps/api/staticmap"
                    + "?center="
                    + singleLat
                    +","
                    +  singleLng
                    + "&zoom="
                    + 14
                    +"&size="
                    + homeRoot.width
                    +"x"
                    +homeRoot.height
                    +"&markers=color:red%7Csize:mid%7C"
                    + singleLat +"," +  singleLng
                    +"&markers=color:blue%7Csize:mid%7C"
                    + gloc.getLocation.lat +"," +  gloc.getLocation.lng
                    +"&sensor=false"
            //
            map.source = singleMapView;

            // add a Bottom Bar that is used for driving this means Updating the models and what not. also.

            var firstModelSource =
                    "http://maps.googleapis.com/maps/api/directions/xml?origin="
                    + gloc.getLocation.lat
                    +","
                    +  gloc.getLocation.lng
                    + "&destination="
                    +searchBar.singleName
                    + "&sensor=false"
                    + "&alternatives="
                    + false
            previewButton.text = searchBar.singleSimpleName
            firstModel.source =  firstModelSource
            firstModel.reload();
//            destLat = searchBar.singleLat
//            destLng = searchBar.singleLng
        }
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
            }
            if(status === XmlListModel.Ready){
                previewButton.opacity = 1
            }
            if(status === XmlListModel.Error){}
        }
    }

    Row{
        width: parent.width
        anchors.bottom: parent.bottom
        Button{
            id: previewButton
            opacity:  0
            width: Math.round(parent.width - goButton.width)
            onClicked: {
                if (directionsLoader.source  === "")
                directionsLoader.source = "../components/SearchOutPut.qml"
            else
                    directionsLoader.source = ""
            }
        }
        Button{
            id: goButton
            opacity:  previewButton.opacity
            text: "GO"
            width:  parent.width / 4
            onClicked: {
                //Start the Directions NOW or Load the OPtions ?
            }
        }
    }
}

