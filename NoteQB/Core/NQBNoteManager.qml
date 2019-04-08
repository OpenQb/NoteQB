import Qb.ORM 1.0
import Qb.Core 1.0
import Qb.ExSql 1.0
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

    property int limit: 100;
    property int currentPage: 1;
    property string currentGroup: ""

    onLimitChanged: {
        currentPage = 1;
        currentGroup = "";
        objNoteManager.refresh();
    }

    /* All methods here */
    function isGroupExists(name)
    {
        noteGroupQuery.resetFilters();
        noteGroupQuery.filter("group", QbORMFilter.EQUAL, name);
        return noteGroupQuery.count() === 1;
    }

    function isNoteFileExists(pk)
    {
        objORM.queryModel.setModel(objORM.noteFile);
        objORM.queryModel.resetFilters();
        objORM.queryModel.filter("pk",QbORMFilter.EQUAL, pk);
        return objORM.queryModel.count() === 1;
    }

    function releaseNoteFile(nf)
    {
        objORM.releaseModel(nf);
    }

    function createNoteFile(pk){
        var m = objORM.newModel2(objORM.noteFile);
        m.pk = pk;
        m.note = "";
        m.bnote = "";
        m.save();
        return m;
    }

    function getNoteFile(pk){
        var m = objORM.newModel2(objORM.noteFile);
        m.pk = pk;
        return m;
    }

    function getNoteMeta(pk){
        var m = objORM.newModel2(objORM.noteMeta);
        m.pk = pk;
        if(m.isExists()) m.one();
        else m.save();
        return m;
    }

    function releaseNoteMeta(nf){
        objORM.releaseModel(nf);
    }

    function trashByIndex(index){
        var nnote = objORM.noteQuery.at(index);
        nnote.status = 1;
        if(nnote.update()){
            refresh();
        }
    }

    function all(){
        objNoteManager.noteQuery.resetFilters();
        objNoteManager.noteQuery.all();
    }

    function refresh()
    {
        if(objNoteManager.currentGroup === "")
        {
            objNoteManager.noteQuery.resetFilters();
            objNoteManager.noteQuery.filter("status",QbORMFilter.EQUAL,0);
            objNoteManager.noteQuery.total();
            objNoteManager.noteQuery.page(objNoteManager.currentPage,objNoteManager.limit);
        }
        else
        {
            objNoteManager.noteQuery.resetFilters();
            objNoteManager.noteQuery.filter("group",QbORMFilter.EQUAL,objNoteManager.currentGroup);
            objNoteManager.noteQuery._and("status",QbORMFilter.EQUAL,0);
            objNoteManager.noteQuery.total();
            objNoteManager.noteQuery.page(objNoteManager.currentPage,objNoteManager.limit);
        }
    }

    function getGroupList()
    {
        objORM.queryModel.setModel(objORM.note);
        objORM.queryModel.resetFilters();
        objORM.queryModel.filter("status",QbORMFilter.EQUAL,0);
        //objORM.queryModel.order("group");
        var values = objORM.queryModel.distinctValueList("group");
        //console.log(JSON.stringify(values));
        return values;
    }

    function search(term)
    {
        var s = "";
        if(term)
        {
            s = term;
        }

        objNoteManager.currentPage = 1;
        objNoteManager.noteQuery.resetFilters();
        objNoteManager.noteQuery.filter("status", QbORMFilter.EQUAL, 0);
        objNoteManager.noteQuery.band_("name", QbORMFilter.CONTAINS, s);
        objNoteManager.noteQuery.or_("group", QbORMFilter.CONTAINS, s);
        objNoteManager.noteQuery.or_("tags", QbORMFilter.CONTAINS, s);
        objNoteManager.noteQuery.total();
        objNoteManager.noteQuery.page(objNoteManager.currentPage, objNoteManager.limit);
    }

    function fullTextSearch(term)
    {
        var s = "";
        if(term)
        {
            s = term;
        }

        objNoteManager.currentPage = 1;
        objNoteManager.noteQuery.resetFilters();
        objNoteManager.noteQuery.jfilter("NQBNote.pk", QbORMFilter.EXACT, "NQBNoteFile.pk");
        objNoteManager.noteQuery.innerJoin("NQBNoteFile");
        objNoteManager.noteQuery.jand_("NQBNote.status", QbORMFilter.EQUAL, 0);
        objNoteManager.noteQuery.jand_("NQBNoteFile.note", QbORMFilter.CONTAINS, s);
        //objNoteManager.noteQuery.jor_("NQBNote.name", QbORMFilter.CONTAINS, s);
        //objNoteManager.noteQuery.jor_("NQBNote.group", QbORMFilter.CONTAINS, s);
        //objNoteManager.noteQuery.jor_("NQBNote.tags", QbORMFilter.CONTAINS, s);
        objNoteManager.noteQuery.total();
        objNoteManager.noteQuery.page(objNoteManager.currentPage, objNoteManager.limit);
    }

    function getPage(pno)
    {
        //objNoteManager.currentPage = pno;
        objNoteManager.noteQuery.page(pno, objNoteManager.limit);
    }


    /**/
    QbORM{
        id: objORM

        onError: {
            NQBOne.error(errorText);
        }

        Component.onDestruction: {
            objORM.closeORM();
        }
        Component.onCompleted: {
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
