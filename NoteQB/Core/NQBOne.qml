pragma Singleton

import Qb.ORM 1.0
import QtQuick 2.0

import "./../../ZeUi" as ZeUi

Item {
    id: objNQBOne

    signal error(string errorText);

    property alias noteDbModelORM: objORM;


    QbORM{
        id: objORM
        dbName: {
            if(ZeUi.ZBLib.appUi){
                return ZeUi.ZBLib.appUi.absoluteDatabasePath("NQBNoteDbModel");
            }
            else{
                return "";
            }
        }

        onError: {
            objNQBOne.error(errorText);
        }

        property Component noteDbModel:Component{
            id: objNoteDbModel
            NQBNoteDbModel{
            }
        }

        property QbORMQuery noteDbModelQuery: QbORMQuery{
            id: objNoteDbModelQuery
            model: objNoteDbModel
        }
    }

}
