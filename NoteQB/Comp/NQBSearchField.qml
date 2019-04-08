import Qb.Core 1.0

import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../../ZeUi" as ZeUi


Rectangle{
    id: objSearchScreen
    color: ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.primary)[QbMetaTheme.Shade50]
    radius: 5
    border.width: 0
    border.color: ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.primary)[QbMetaTheme.Shade300]

    property string searchTerm;
    property string placeHolderText: "Search"

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
        color: ZeUi.ZBTheme.primary

    }

    Text{
        id: objPlaceHolderText
        text: objSearchScreen.placeHolderText
        color: ZeUi.ZBTheme.primary
        anchors.left: objSearchIcon.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5
        verticalAlignment: TextInput.AlignVCenter
        font.family: ZeUi.ZBTheme.defaultFontFamily
        font.pixelSize: 20
        font.bold: true
        activeFocusOnTab: false
        opacity: 1
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
        onFocusChanged: {
            //console.log("TextInput Focus:",focus)
        }
        onTextChanged: {
            if(objSearchField.text.length === 0)
            {
                objPlaceHolderText.opacity = 1;
            }
            else
            {
                objPlaceHolderText.opacity = 0;
            }
            objSearchScreen.searchTerm = text;
        }
    }

    MouseArea{
        anchors.fill: parent
        preventStealing: true
        onPressed: {
            objSearchField.forceActiveFocus();
        }
    }
}
