pragma Singleton

import Qb 1.0
import Qb.Core 1.0
import Qb.ORM 1.0
import QtQuick 2.0

import "./../../ZeUi" as ZeUi

Item {
    id: objNQBOne

    property string lastPath;

    signal error(string errorText);
    signal refresh();

    property alias noteDbModelORM: objORM;

    QbSettings{
        id: objSettings
        name: "NQBOne"
        property alias lastPath: objNQBOne.lastPath
        Component.onCompleted: {
            objSettings.setAppId(ZeUi.ZBLib.appUi.appId);
        }
    }

    QbOneOneMap{
        id: objOneOneMap
    }


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

    function addNoteDb(data){
        return objORM.noteDbModelQuery.add(data);
    }

    function isNoteDbExists(path){
        objORM.noteDbModelQuery.resetFilters();
        return objORM.noteDbModelQuery.filter("path",QbORMFilter.EQUAL,path).count() === 1;
    }

    function removeNoteDbByIndex(index){
        if(objNoteDbModelQuery.remove(index)){
        }
    }


    function openNoteDb(path)
    {
        console.log("Open:"+path);
        if(!objOneOneMap.isValueExists(path))
        {
            objOneOneMap.append(QbUtil.fileNameWithoutExtFromPath(path),path);
            //ZeUi.ZBLib.appUi.addPage("/StudioQB/ProjectPage.qml",d);
        }
        else
        {
            var index = objOneOneMap.indexOfValue(path);
            ZeUi.ZBLib.appUi.changePage(index);
        }
        return true;
    }

    function openNoteDbX(path,password){

    }

    function closeNoteDb(path){
        console.log("Close:"+path);
        if(objOneOneMap.isValueExists(path))
        {
            var index = objOneOneMap.indexOfValue(path);
            ZeUi.ZBLib.appUi.closePage(index);
            objOneOneMap.remove(index);
            return true;
        }
        return false;
    }

    function removeNoteDb(path){
        console.log("Remove:"+path);
        closeNoteDb(path);
        var index = objNoteDbModelQuery.indexOf("path",path);
        if(index !== -1){
            removeNoteDbByIndex(index);
        }
    }


    function addPage(name,path){
        if(!objOneOneMap.isKeyExists(name))
        {
            objOneOneMap.append(name,path);
            ZeUi.ZBLib.appUi.addPage(path,{});
            return true;
        }
        else
        {
            var index = objOneOneMap.indexOf(name);
            ZeUi.ZBLib.appUi.changePage(index);
            return true;
        }
    }

}
