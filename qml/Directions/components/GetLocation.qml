//QT
import QtQuick 2.0
import QtQuick.XmlListModel 2.0
Item {
    id: info
    property bool ready: geoLoc.status == XmlListModel.Ready
    property variant getLocation: null
    XmlListModel {
        id: geoLoc
        source: "http://geoip.ubuntu.com/lookup"
        query: "/Response"
        XmlRole { name: "lat"; query: "Latitude/string()" }
        XmlRole { name: "lng"; query: "Longitude/string()" }
        onStatusChanged: if (status == XmlListModel.Ready) {
                             if (count > 0)
                                 info.getLocation = geoLoc.get(0)
                         }
    }
}
