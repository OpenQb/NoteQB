import Qb 1.0
import Qb.Core 1.0
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
    contextDock: objContextDock

    onPageCreated: {
        //console.log(objMainAppUi);
    }

    onSelectedContextDockItem: {
        //title
        if(title === "Close")
        {
            QbUtil.getObject("com.cliodin.qb.NoteQB.NQBOne").closeCurrentNote();
        }
    }

    ListModel{
        id: objContextDock
        ListElement{
            icon: "mf-cancel"
            title: "Close"
        }
        ListElement{
            icon: "mf-refresh"
            title: "Refresh"
        }
    }


    Rectangle{
        anchors.fill: parent


    }
}
