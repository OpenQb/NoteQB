import Qb.ORM 1.0

import QtQuick 2.10
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "./../../ZeUi" as ZeUi
import "./../Core" as Core

ZeUi.ZSOneAppPage{
    id: objErrorPage
    title: "NoteQB"



    QbORMQueryModel{
        id: objNoteDbQueryModel
        limit: 1000
        query: Core.NQBOne.noteDbModelORM.noteDbModelQuery
    }

    onPageCreated: {
        objNoteDbQueryModel.search(["path","meta"]);
    }
}
