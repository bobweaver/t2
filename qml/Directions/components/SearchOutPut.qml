import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1
Page {
    id: previewsRoot
    width: parent.width
    height: parent.height
    property double simpleLat
    property double simpleLng
    title: "Preview"
    Image {
        id: name
        source: "http://maps.googleapis.com/maps/api/streetview?"
                        +"size=" + parent.height + "x" + parent.width / 2
                        +"&location=" + destLat +","+ destLng
                        +"&sensor=false"
    }
 Component.onCompleted:  console.log( name.source)
}
