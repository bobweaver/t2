//Qt
import QtQuick 2.0
import QtQuick.XmlListModel 2.0
//Ubuntu
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
Rectangle  {
    id: searchRoot
    width: parent.width
    height: parent.height
    color: "transparent"
    property string referenceNumber
    property double singleLat
    property double singleLng
    property string singleName
    property string  singleSimpleName
    property bool singleChecker: false
    signal clicked
    GetLocation{id:gloc}
    GReverseGeo{id:grev}
    //remove rec
    Rectangle{
        id: searchInputRec
        color: "transparent"
        width: parent.width
        height: parent.height / 12
        TextField{
            id: searchInput
            width: parent.width
            height: parent.height
            placeholderText: "Search"
            text: ""
            color: "black"
            focus: true
            cursorVisible: false
            onTextChanged: {
                placesModel.reload();
            }
        }
        Rectangle{
            id:out
            width: parent.width
            //fix me make dynamic as search results come in.
            height: placesModel.count > 0 ?  searchRoot.height - parent.height : 0
            anchors.top: searchInputRec.bottom
            color: "transparent"
            ListView{
                id: searchViewer
                anchors.fill: parent
                model: placesModel
                spacing: 1
                delegate:
                    Item {
                    width: parent.width
                    height: searchInputRec.height +units.dp(4)
                    Column{
                        anchors.fill:  parent
                        spacing: 1
                        ListItem.ThinDivider{}
                        Button{
                            width: parent.width
                            height: searchInputRec.height
                            text: description
                            onClicked:{
                                if (searchViewer.model === placesModel){
                                 searchRoot.referenceNumber = linker
                                 singlePlacesModel.reload()
                                searchInput.text = ""
//                                    console.log(singlePlacesModel.source)
                                }else {
                                    console.log( "this is now single Mode")
                                }
//                                searchInput.text = ""
                            }
                        }
                        ListItem.ThinDivider{}
                    }
                }
            }
        }
    }

    XmlListModel{
        id: placesModel
        source:
            "https://maps.googleapis.com/maps/api/place/autocomplete/xml?"
            + "input="+ searchInput.text
            +"&types="
            +"&location=" + gloc.getLocation.lat + "," + gloc.getLocation.lng
            +"&radius=500"
            +"&sensor=false"
            +"&key=AIzaSyBh098qmiYvAD51ZOhXMu0fxQPQX1zGgtg"
        query: "/AutocompletionResponse/prediction"
        XmlRole{name: "description"; query: "description/string()"}
        XmlRole{name:"linker"; query:"reference/string()"}
        onStatusChanged: {
            if(status === XmlListModel.Error)
                console.log("ALERT ALERT "+errorString())
        console.log(source)
        }
    }


    XmlListModel{
        id: singlePlacesModel
        source: {
            "https://maps.googleapis.com/maps/api/place/details/xml"
                    +"?reference="+  searchRoot.referenceNumber
                    + "&sensor=false"
                    +"&key=AIzaSyBh098qmiYvAD51ZOhXMu0fxQPQX1zGgtg"
        }

        query: "/PlaceDetailsResponse/result"
        XmlRole{name: "description"; query: "formatted_address/string()"}
        XmlRole{name: "name"; query: "name/string()"}
        XmlRole{name:"lat"; query:"geometry/location/lat/string()"}
        XmlRole{name:"lng"; query:"geometry/location/lng/string()"}
        onStatusChanged:{
            if (status === XmlListModel.Ready ){
                            singleLat = get(0).lat
                            singleLng = get(0).lng
                            singleName = get(0).description
                            singleSimpleName = get(0).name
                            singleChecker = true
                            searchRoot.clicked()
            }
    }
}
}
