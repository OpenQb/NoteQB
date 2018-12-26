import Qb.ORM 1.0
import QtQuick 2.0

QbORMModel{
    tableName: "NQBNoteFile";

    pk: QbORMField.unsignedBigIntegerNumber(0,true,true); /* Note PK */

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


    property var updated: QbORMField.timestamp(0,true,true);
    property var created: QbORMField.timestamp(0,true,false);
}
