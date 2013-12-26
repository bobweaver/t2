// QT
import QtQuick 2.0
import QtWebKit 3.0
import Ubuntu.Components 0.1
UbuntuShape {
    id:root
    width: parent.width
    height: parent.height
    property string  center // start_address
    property string  mapType: "roadmap" // roadmap, satellite, hybrid, and terrain.
    property int zoom: 7
    property string pathLines
    property int mapScale: 2
    property string markerColor: "red"
    property string startingLng
    property string startingLat
    property string endingLng
    property string endingLat
    property bool  sensors: false
    property string pathColor: "green"
    property int pathWeight: 5
    property bool progression: map.progress < 70 ? true : false
    WebView{
        id: map
        width: parent.width
        height: parent.height
        url:{
      "http://maps.googleapis.com/maps/api/staticmap?"
//            + "center="  + root.center
            + "&size="+ width * 4 +"x" +Math.round(root.height * 4)
            + "&maptype="+ root.mapType
//            +"&zoom=" +root.zoom
            +"&scale=2"// + root.mapScale
            +"&markers=color:"+ root.markerColor+"%7Clabel:A%7C"+root.startingLat + ","+root.startingLng
            +"&markers=color:"+root.markerColor+"%7Clabel:B%7C"+ root.endingLat+","+ root.endingLng
           + "&path=weight:"+root.pathWeight+"%7Ccolor:"+root.pathColor+"%7Cenc:"+root.pathLines
           +"&sensor="+ root.sensors

        }
        Component.onCompleted: {console.log(width)}

    }
}
