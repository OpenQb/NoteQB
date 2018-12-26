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

    property alias keyValuePair: objORM.keyValuePair
    property alias keyValuePairQuery: objORM.keyValuePairQuery

    /* All methods here */
    function isFolderExists(name)
    {
        noteFolderQuery.resetFilters();
        noteFolderQuery.filter("folder", QbORMFilter.EQUAL, name);
        noteFolderQuery.filter("ppk", QbORMFilter.EQUAL, 0);
        return noteFolderQuery.count() === 1;
    }

    function getTagPk(tag){
        noteTagQuery.resetFilters();
        noteTagQuery.filter("tag", QbORMFilter.EQUAL, tag);

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

        property QbORMQuery noteQuery: QbORMQuery{
            model: objORM.note
        }

        property Component noteFile:Component{
            Models.NQBNoteFile{
            }
        }

        property Component noteGroup:Component{
            Models.NQBNoteGroup{
            }
        }

        property QbORMQuery noteGroupQuery: QbORMQuery{
            model: objORM.noteGroup
        }

        property Component noteMeta:Component{
            Models.NQBNoteMeta{
            }
        }

        property Component keyValuePair:Component{
            Models.NQBKeyValuePair{
            }
        }

        property QbORMQuery keyValuePairQuery: QbORMQuery{
            model: objORM.keyValuePair
        }

    }
}
