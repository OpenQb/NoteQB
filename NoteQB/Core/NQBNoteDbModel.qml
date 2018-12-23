import Qb.ORM 1.0
import QtQuick 2.0


QbORMModel{
    id: objNQBNoteModel
    tableName: "NQBNoteDbModel";

    property var path: QbORMField.ustring("");
    property var meta:  QbORMField.json({})

    property var created: QbORMField.timestamp(0,true,false);
    property var updated: QbORMField.timestamp(0,true,true);
}
