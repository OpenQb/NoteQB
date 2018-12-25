import Qb.ORM 1.0
import QtQuick 2.0

QbORMModel{
    tableName: "NQBNote";
    pk: QbORMField.puid();

    property var folderPk: QbORMField.unsignedBigIntegerNumber();


    property var name: QbORMField.charField(
                           "", /*default value*/
                           512 /*maxLength*/
                           );

    property var note: QbORMField.string(
                           "", /*default value*/
                           false, /*isUnique*/
                           false, /*isPrimaryKey*/
                           "Note", /*label*/
                           false,/*isVisible*/
                           false,/*isEditable*/
                           false/*isSelectable*/
                           );

    property var bnote: QbORMField.binary(
                            "",
                            "Binary Note", /*label*/
                            false, /*isVisible*/
                            false, /*isEditable*/
                            false /*isSelectable*/
                            );


    property var status: QbORMField.integerNumber(0); /*0 means active,1 means trashed,2 means archived*/



    property var updated: QbORMField.timestamp(0,true,true);
    property var created: QbORMField.timestamp(0,true,false);
    property var reminder: QbORMField.timestamp(0,false,false);
}
