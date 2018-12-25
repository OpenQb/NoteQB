import Qb.ORM 1.0
import QtQuick 2.0

QbORMModel{
    tableName: "NQBNoteTag";
    pk: QbORMField.puid();

    property var tag: QbORMField.charField("",512);


    property var updated: QbORMField.timestamp(0,true,true);
    property var created: QbORMField.timestamp(0,true,false);
}
