import Qb.ORM 1.0
import QtQuick 2.0


QbORMModel{
    tableName: "NQBKeyValuePair";
    property var name: QbORMField.charField("",512/*maxLength*/,true/*isUnique*/);
    property var value:  QbORMField.variant("")

    property var updated: QbORMField.timestamp(0,true,true);
    property var created: QbORMField.timestamp(0,true,false);
}
