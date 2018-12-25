import Qb.ORM 1.0
import QtQuick 2.0

QbORMModel{
    tableName: "NQBNoteMeta";
    pk: QbORMField.puid();

    property var meta:  QbORMField.json({});
    property var name: QbORMField.charField("",512);
    property var notePk: QbORMField.unsignedBigIntegerNumber();



    property var updated: QbORMField.timestamp(0,true,true);
    property var created: QbORMField.timestamp(0,true,false);
}
