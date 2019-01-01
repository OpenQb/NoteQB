import Qb.Core 1.0

import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../../ZeUi" as ZeUi

Rectangle{
    id: objSearchScreen
    visible: false

    property alias searchTerm: objSearchField.text
    property var lastActiveItem;


    Keys.onPressed: {
        event.accepted = true;
        //console.log("Search screen event",event);
        if(event.key === Qt.Key_Escape || event.key === Qt.Key_Back)
        {
            objSearchScreen.closeSearchWindow();
        }
        else if(event.key === Qt.Key_Return||event.key === Qt.Key_Enter)
        {
            objSearchScreen.closeSearchWindow();
        }
        else
        {
            objSearchField.forceActiveFocus();
            objSearchField.focus = true;
        }
    }
    Keys.onReleased: {
        event.accepted = true;
    }

    Keys.forwardTo: [objSearchField]

    MouseArea{
        anchors.fill: parent
        preventStealing: true
        onPressed: {
            objSearchField.forceActiveFocus();
            objSearchField.focus = true;
        }
    }

    Rectangle{
        width: parent.width*0.80
        height: 50
        color: "lightgrey"
        radius: 5
        y: (parent.height/4.0)*1
        x: (parent.width-width)/2.0

        Text{
            id: objSearchIcon
            anchors.left: parent.left
            anchors.top: parent.top
            width: 50
            height: parent.height
            text: QbCoreOne.icon_font_text_code("mf-search")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: QbCoreOne.icon_font_name("mf-search")
            font.pixelSize: parent.height*0.60
            color: "grey"
        }

        TextInput {
            id: objSearchField
            anchors.left: objSearchIcon.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 5
            verticalAlignment: TextInput.AlignVCenter
            font.family: ZeUi.ZBTheme.defaultFontFamily
            font.pixelSize: 20
            font.bold: true
            activeFocusOnPress: true
            selectionColor: "lightblue"
            selectedTextColor: "black"
            color: "black"
            property string placeholderText: qsTr("Search")
            onFocusChanged: {
                console.log("TextInput Focus:",focus)
            }
        }

    }

    function openSearchWindow()
    {
        objSearchField.text = "";
        objSearchScreen.lastActiveItem = appUi.getCurrentFocusItem();
        objSearchScreen.lastActiveItem.focus = false;

        objSearchScreen.visible = true;
        objSearchScreen.forceActiveFocus();
        objSearchScreen.focus = true;

        objSearchScreen.lastActiveItem.focus = false;
        objSearchField.forceActiveFocus();
        objSearchField.focus = true;

        objSearchScreen.lastActiveItem.focus = false;
        objSearchField.forceActiveFocus();
        objSearchField.focus = true;
    }

    function closeSearchWindow()
    {
        objSearchScreen.visible = false;
        objSearchScreen.focus = false;
        if(objSearchScreen.lastActiveItem){
            objSearchScreen.lastActiveItem.forceActiveFocus();
            objSearchScreen.lastActiveItem.focus = true;
        }
        appUi.resetAndroidFullScreenState();
    }
}
