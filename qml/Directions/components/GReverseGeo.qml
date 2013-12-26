//QT
import QtQuick 2.0
import QtQuick.XmlListModel 2.0
Item {
    id: info
    GetLocation{id:loc}
    property string getLat:  loc.getLocation.lat
    property string getLong:  loc.getLocation.lng
    property bool ready: geoRev.status == XmlListModel.Ready
    property variant getLocation: null
    XmlListModel {
        id: geoRev
        source: "http://maps.googleapis.com/maps/api/geocode/xml?latlng="
                +
                loc.getLocation.lat
                +
                ","
                +
                loc.getLocation.lng
                +"&sensor=true"

        query: "/GeocodeResponse"
        XmlRole { name: "address"; query: "result[1]/formatted_address/string()" }
        onStatusChanged: if (status == XmlListModel.Ready) {
                             if (count > 0)
                                 info.getLocation = geoRev.get(0)
                         }
    }
}

