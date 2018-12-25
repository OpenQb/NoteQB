import Qb.ORM 1.0
import QtQuick 2.0

QbORMModel{
    tableName: "NQBNoteFolder";
    pk: QbORMField.puid();

    property var folder: QbORMField.charField("",512);
    property var ppk: QbORMField.unsignedBigIntegerNumber();



    property var updated: QbORMField.timestamp(0,true,true);
    property var created: QbORMField.timestamp(0,true,false);
}
