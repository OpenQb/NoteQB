import QtQuick 2.10
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "./../../ZeUi" as ZeUi

ZeUi.ZSOneAppPage{
    id: objErrorPage
    title: "Error"
    property string errorText: "Qb " + QbApplicationVersion + "\n"
                               +"Build number: " + QbApplicationBuildNumber + "\n"
                               +"NoteQB does not support this version of Qb now\n"
                               +"Please download and use the latest version of Qb"

    onPageCreated: {

    }

    Rectangle{
        anchors.fill: parent
        color: "lightgrey"

        Text{
            id: objErrorText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: parent.height - 200
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "grey"
            text: objErrorPage.errorText
            font.pixelSize: 18
        }

        Button{
            anchors.top: objErrorText.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: "DOWNLOAD LATEST VERION"
            Material.background: ZeUi.ZBTheme.primary
            Material.accent: ZeUi.ZBTheme.accent
            onClicked: {
                Qt.openUrlExternally("https://bit.ly/2RdEjit");
            }
        }

    }
}
