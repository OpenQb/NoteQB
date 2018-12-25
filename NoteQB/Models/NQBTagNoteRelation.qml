import Qb.ORM 1.0
import QtQuick 2.0

QbORMModel{
    tableName: "NQBTagNoteRelation";
    pk: QbORMField.puid();


    property var tagPk: QbORMField.charField("",512);
    property var notePk: QbORMField.unsignedBigIntegerNumber();
}
