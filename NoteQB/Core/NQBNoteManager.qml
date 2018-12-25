import Qb.ORM 1.0
import QtQuick 2.10

Item {
    id: objNoteManager

    property alias orm: objORM

    property alias dbPath: objORM.dbName
    property alias dbDriver: objORM.dbDriver
    property alias password: objORM.password
    property alias autoSetup: objORM.autoSetup
    property alias masterPassword: objORM.masterPassword
    property alias masterPasswordIterationCount: objORM.masterPasswordIterationCount

    QbORM{
        id: objORM

        onError: {
            NQBOne.error(errorText);
        }


    }


}
