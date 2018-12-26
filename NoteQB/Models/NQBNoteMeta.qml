import Qb.ORM 1.0
import QtQuick 2.0

QbORMModel{
    tableName: "NQBNoteMeta";
    pk: QbORMField.unsignedBigIntegerNumber(0,true,true); /* Note PK */

    property var meta:  QbORMField.variant("");

    property var updated: QbORMField.timestamp(0,true,true);
    property var created: QbORMField.timestamp(0,true,false);
}
