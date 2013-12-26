//QT
import QtQuick 2.0
import QtQuick.XmlListModel 2.0

//Ubuntu
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
Page{
    id:steps
    width: parent.width
    height: parent.height
    title: "directions"
    property int route
    property string source
    ActivityIndicator{
        id: act
        anchors.centerIn: parent
    }

    ListView{
         id: mod
        width: parent.width
        height: parent.height
        model: gDirections
        delegate:
            StepView{
           id: stepsView
            width: parent.width
            height: units.gu(20)
            distance: distanceTo
            duration: durationTo
            text: step
            onClicked:{
                var innerText = text
                var strippedText = innerText.replace(/(<([^>]+)>)/ig,"")
                speechEngine.text = strippedText
                speechEngine.speech();
                speechEngine.text = ""
            }
            icon:{
                function getArrow(){
                    var   s = step
                    var isRight  = s.search("<b>right</b>")
                    var isLeft = s.search("<b>left</b>")
                    var isWest = s.search("<b>west</b>")
                    var isNorth = s.search("<b>north</b>")
                    var isSouth = s.search("<b>south</b>")
                    var isEast= s.search("<b>east</b>")
                    if (isRight  >  0 )
                        return "right"
                    if (isLeft > 0 )
                        return "left"
                    if(isNorth > 0)
                        return "north"
                    if(isSouth > 0)
                        return "south"
                    if(isEast > 0)
                        return "east"
                    if(isWest > 0)
                        return "west"
                }
                getArrow()
            }
        }
        ListItem.ThinDivider{}
    }


    XmlListModel {
        id: gDirections
        source: steps.source
        query:{
            var realRoute = parseInt(route) +1
            "/DirectionsResponse/route["+realRoute+"]/leg/step"
       }
            XmlRole { name: "step"; query: "html_instructions/string()" }
        XmlRole { name: "durationTo"; query: "duration/text/string()" }
        XmlRole { name: "distanceTo"; query: "distance/text/string()" }
        onSourceChanged: reload()
        onStatusChanged:{
            if (status == XmlListModel.Loading) {
                          act.running = true
            }
            if (status == XmlListModel.Error){
                act.running = true
            console.log(errorString())
        }
        if(status === XmlListModel.Ready){
    act.running = false
            console.log("Ready ? ")
        }
    }
}

}
