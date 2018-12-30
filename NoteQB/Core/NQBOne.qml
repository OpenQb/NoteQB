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
    signal requestForPassword();

    property alias noteDbModelORM: objORM;


    onError: {
        console.log(errorText);
    }

    Component.onCompleted: {
        console.log("NQBOne created.");
        QbUtil.addObject("com.cliodin.qb.NoteQB.NQBOne",objNQBOne);
    }

    Component.onDestruction: {
        QbUtil.removeObject("com.cliodin.qb.NoteQB.NQBOne");
    }

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
            objNQBOne.requestForPassword();
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

            ZeUi.ZBLib.appUi.addPage("/NoteQB/pages/NoteDb.qml",m);
        }
        else
        {
            var index = objOneOneMap.indexOfValue(path);
            ZeUi.ZBLib.appUi.changePage(index);
        }
        return true;
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
        var index = objORM.noteDbModelQuery.indexOf("path",path);
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
            ZeUi.ZBLib.appUi.addPage("NoteQB/pages/NoteView.qml",m);
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
            ZeUi.ZBLib.appUi.closePage(pindex);
            objOneOneMap.remove(pindex);
            return true;
        }
        return false;
    }

    function closeCurrentNote(){
        var i = QbUtil.getObject("com.cliodin.qb.NoteQB").pageView.currentIndex;
        QbUtil.getObject("com.cliodin.qb.NoteQB").closePage(i);
        objOneOneMap.remove(i);
    }

    function deleteNote(title,manager,pk,index){
        console.log("Delete Note");
        closeNote(title,manager,pk,index);
        manager.trashByIndex(index);
    }

}
