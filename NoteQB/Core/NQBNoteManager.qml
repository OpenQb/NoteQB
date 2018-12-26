import Qb.ORM 1.0
import QtQuick 2.10

import "./../Models" as Models

Item {
    id: objNoteManager

    property alias orm: objORM

    property alias dbPath: objORM.dbName
    property alias dbDriver: objORM.dbDriver
    property alias password: objORM.password
    property alias autoSetup: objORM.autoSetup
    property alias masterPassword: objORM.masterPassword
    property alias masterPasswordIterationCount: objORM.masterPasswordIterationCount


    property alias note: objORM.note
    property alias noteFile: objORM.noteFile
    property alias noteMeta: objORM.noteMeta
    property alias noteQuery: objORM.noteQuery


    property alias noteGroup: objORM.noteGroup
    property alias noteGroupQuery: objORM.noteGroupQuery


    property alias noteTag: objORM.noteTag
    property alias keyValuePair: objORM.keyValuePair
    property alias queryModel: objORM.queryModel

    /* All methods here */
    function isGroupExists(name)
    {
        noteGroupQuery.resetFilters();
        noteGroupQuery.filter("group", QbORMFilter.EQUAL, name);
        return noteGroupQuery.count() === 1;
    }


    /**/

    QbORM{
        id: objORM

        onError: {
            NQBOne.error(errorText);
        }

        property Component note:Component{
            Models.NQBNote{
            }
        }

        property Component noteFile:Component{
            Models.NQBNoteFile{
            }
        }

        property Component noteMeta:Component{
            Models.NQBNoteMeta{
            }
        }

        property QbORMQuery noteQuery: QbORMQuery{
            model: objORM.note
        }

        property Component noteGroup:Component{
            Models.NQBNoteGroup{
            }
        }

        property QbORMQuery noteGroupQuery: QbORMQuery{
            model: objORM.noteGroup
        }


        property Component noteTag:Component{
            Models.NQBNoteTag{
            }
        }

        property Component keyValuePair:Component{
            Models.NQBKeyValuePair{
            }
        }


        property QbORMQuery queryModel: QbORMQuery{
            model: objORM.keyValuePair /*default model*/
        }

    }
}
