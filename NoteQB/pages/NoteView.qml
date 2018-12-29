import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../../ZeUi" as ZeUi
import "./../Comp" as Comp
import "./../Core" as Core
import "./../Models" as Models

ZeUi.ZPage{
    id: objPage
    title: "Note View"

    property variant pk: null;
    property Models.NQBNoteFile noteFile: null
    property Core.NQBNoteManager noteManager: null

    onPageCreated: {
    }


    Rectangle{
        anchors.fill: parent


    }
}
