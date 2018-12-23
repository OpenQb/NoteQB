import Qb.ORM 1.0
import QtQuick 2.0


QbORMModel{
    id: objNQBNoteModel
    tableName: "NQBNoteModel";
    pk: QbORMField.puid();

    property var name: QbORMField.charField("",512);
    property var group: QbORMField.charField("",512);
    property var tags: QbORMField.string("");
    property var note: QbORMField.string("");
    property var meta:  QbORMField.json({})

    property var created: QbORMField.timestamp(0,true,false);
    property var updated: QbORMField.timestamp(0,true,true);
}
