import Qb.ORM 1.0
import QtQuick 2.0

QbORMModel{
    tableName: "NQBNote";
    pk: QbORMField.puid();

    property var name: QbORMField.charField(
                           "", /*default value*/
                           512 /*maxLength*/
                           );

    property var group: QbORMField.charField(
                           "", /*default value*/
                           512 /*maxLength*/
                           );

    property var tags: QbORMField.json(
                           [], /*default value*/
                           "Tags", /*label*/
                           false,/*isVisible*/
                           false,/*isEditable*/
                           true/*isSelectable*/
                           );

    property var status: QbORMField.integerNumber(0); /* 0 means active, 1 means trashed, 2 means archived */
    property var reminder: QbORMField.timestamp(0,false,false);

    property var updated: QbORMField.timestamp(0,true,true);
    property var created: QbORMField.timestamp(0,true,false);

}
