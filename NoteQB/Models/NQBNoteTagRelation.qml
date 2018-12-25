import Qb.ORM 1.0
import QtQuick 2.0

QbORMModel{
    tableName: "NQBNoteTagRelation";
    pk: QbORMField.puid();


    property var tagPk: QbORMField.unsignedBigIntegerNumber();
    property var notePk: QbORMField.unsignedBigIntegerNumber();
}
