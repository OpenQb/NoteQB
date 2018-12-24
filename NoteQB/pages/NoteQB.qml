import Qb.ORM 1.0

import QtQuick 2.10
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "./../../ZeUi" as ZeUi
import "./../Core" as Core
import "./../Comp" as Comp

ZeUi.ZSOneAppPage{
    id: objErrorPage
    title: "NoteQB"
    contextDock: objContextDock

    onSelectedContextDockItem: {
        //title
        if(title === "Add"){
            objAddNoteDb.resetFields();
            objAddNoteDb.open();
        }
    }

    ListModel{
        id: objContextDock
        ListElement{
            icon: "mf-library_add"
            title: "Add"
        }
        ListElement{
            icon: "mf-refresh"
            title: "Refresh"
        }
    }

    QbORMQueryModel{
        id: objNoteDbQueryModel
        limit: 1000
        query: Core.NQBOne.noteDbModelORM.noteDbModelQuery
    }


    /* All Dialogs will be here*/
    Comp.NQBAddNoteDb{
        id: objAddNoteDb
        anchors.fill: parent
        onNoteDbAdded: {
            objAddNoteDb.close();
        }
    }
    /* end dialog space*/

    onPageCreated: {
        objNoteDbQueryModel.search(["path","meta"]);
    }
}
