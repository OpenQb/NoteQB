pragma Singleton

import Qb 1.0
import Qb.Core 1.0
import Qb.ORM 1.0
import QtQuick 2.0

import "./../../ZeUi" as ZeUi

Item {
    id: objNQBOne
    objectName: "com.cliodin.qb.NoteQB.NQBOne"
    property string lastPath;
    property Item appUi: null;

    signal error(string errorText);
    signal refresh();
    signal requestForPassword(string path);

    property alias noteDbModelORM: objORM;
    property alias oneOneMap: objOneOneMap;
    property string appId;

    onError: {
        console.log(errorText);
    }

    Component.onCompleted: {
        console.log("NQBOne created.");
        objSettings.setAppId(ZeUi.ZBLib.appUi.appId);
    }

    QbSettings{
        id: objSettings
        name: "NQBOne"
        property alias lastPath: objNQBOne.lastPath
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
            NQBNoteDbModel{
            }
        }
        property QbORMQuery noteDbModelQuery: QbORMQuery{
            model: objORM.noteDbModel
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
        if(objORM.noteDbModelQuery.remove(index)){
        }
    }


    function openNoteDb(path)
    {
        if(!QbUtil.stringIEndsWith(path,".QDBX"))
        {
            openNoteDbX(path,"");
        }
        else
        {
            objNQBOne.requestForPassword(path);
        }
    }

    function openNoteDbX(path,password){
        //console.log("Open:"+path);
        //console.log("isExists:"+objOneOneMap.isValueExists(path))
        if(!objOneOneMap.isValueExists(path))
        {
            var title = QbUtil.fileNameFromPath(path);
            objOneOneMap.append(title,path);
            var m = {};
            m["title"] = title;
            m["path"] = path;

            if(QbUtil.stringIEndsWith(path,".QDBX"))
            {
                m["password"] = password;
                m["isPasswordProtected"] = true;
            }
            console.log(JSON.stringify(m));

            QbUtil.getAppObject(objNQBOne.appId,"appUi").addPage("/NoteQB/pages/NoteDb.qml",m);
        }
        else
        {
            var index = objOneOneMap.indexOfValue(path);
            QbUtil.getAppObject(objNQBOne.appId,"appUi").changePage(index);
        }
        return true;
    }

    function closeNoteDb(path){
        console.log("Close:"+path);
        if(objOneOneMap.isValueExists(path))
        {
            var index = objOneOneMap.indexOfValue(path);
            QbUtil.getAppObject(objNQBOne.appId,"appUi").closePage(index);
            objOneOneMap.remove(index);
            return true;
        }
        return false;
    }

    function removeNoteDb(path){
        console.log("Remove:"+path);
        closeNoteDb(path);
        var index = objORM.noteDbModelQuery.indexOf("path",path);
        if(index !== -1){
            removeNoteDbByIndex(index);
        }
    }


    function addPage(name,path){
        if(!objOneOneMap.isKeyExists(name))
        {
            objOneOneMap.append(name,path);
            QbUtil.getAppObject(objNQBOne.appId,"appUi").addPage(path,{});
            return true;
        }
        else
        {
            var index = objOneOneMap.indexOf(name);
            QbUtil.getAppObject(objNQBOne.appId,"appUi").changePage(index);
            return true;
        }
    }

    function openNote(title,manager,pk,index){
        console.log("Open Note");
        console.log("Manager:"+manager);
        console.log("pk:"+pk);
        console.log("index:"+index);

        if(!objOneOneMap.isKeyExists(pk))
        {
            var m = {};
            m["title"] = title;
            m["noteManager"] = manager;
            m["pk"] = pk;
            objOneOneMap.append(pk,title);
            QbUtil.getAppObject(objNQBOne.appId,"appUi").addPage("NoteQB/pages/NoteView.qml",m);
            return true;
        }
        else
        {
            var pindex = objOneOneMap.indexOf(pk);
            ZeUi.ZBLib.appUi.changePage(pindex);
            return true;
        }
    }

    function closeNote(title,manager,pk,index){
        console.log("Close Note");
        if(objOneOneMap.isKeyExists(pk))
        {
            var pindex = objOneOneMap.indexOf(pk);
            QbUtil.getAppObject(objNQBOne.appId,"appUi").closePage(pindex);
            objOneOneMap.remove(pindex);
            return true;
        }
        return false;
    }

    function closeCurrentNote(){
        var i = QbUtil.getAppObject(objNQBOne.appId,"appUi").pageView.currentIndex;
        ZeUi.ZBLib.appUi.closePage(i);
        objOneOneMap.remove(i);
    }

    function closeCurrentNoteDb()
    {
        var i = QbUtil.getAppObject(objNQBOne.appId,"appUi").pageView.currentIndex;
        ZeUi.ZBLib.appUi.closePage(i);
        objOneOneMap.remove(i);
    }

    function deleteNote(title,manager,pk,index){
        console.log("Delete Note");
        closeNote(title,manager,pk,index);
        manager.trashByIndex(index);
    }

    function closeAll(){
        var pindex = objOneOneMap.lastIndex();
        while(pindex)
        {
            QbUtil.getAppObject(objNQBOne.appId,"appUi").closePage(pindex);
            objOneOneMap.remove(pindex);
            objOneOneMap.remove(pindex);
            --pindex;
        }
        objOneOneMap.remove(pindex);
        objOneOneMap.remove(pindex);
    }

}
