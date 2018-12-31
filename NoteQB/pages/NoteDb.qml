import Qb 1.0
import Qb.ORM 1.0
import Qb.Core 1.0

import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../../ZeUi" as ZeUi
import "./../../NoteQB"
import "./../Comp" as Comp
import "./NoteDBComp" as NoteDBComp

ZeUi.ZPage{
    id: objPage
    title: "Note Db"

    property string path: "";
    property string password: "";

    property bool isPasswordProtected: false;
    property bool isDbReady: false;
    property int dbVersion: 1

    signal sigAddGroup();
    signal sigAddNote();


    contextDock: objContextDock
    activeFocusOnTab: false
    Keys.forwardTo: [objNoteListView]

    onSelectedContextDockItem: {
        //title
        if(title === "Add Note")
        {
            objAddNote.isUpdate = false;
            objAddNote.resetFields();
            objAddNote.open();
        }
        else if(title === "Edit Note")
        {
            if(objNoteListView.currentIndex !==-1){
                var m = objNoteManager.noteQuery.at(objNoteListView.currentIndex).toMap();
                objAddNote.isUpdate = true;
                objAddNote.resetFields();
                objAddNote.setDataMap(m);
                objAddNote.open();
            }
        }
        else if(title === "Refresh")
        {
            objPage.refresh();
        }
    }

    ListModel{
        id: objContextDock
        ListElement{
            icon: "mf-add_box"
            title: "Add Note"
        }
        ListElement{
            icon: "mf-edit"
            title: "Edit Note"
        }
        ListElement{
            icon: "mf-view_list"
            title: "Groups"
        }
        ListElement{
            icon: "mf-refresh"
            title: "Refresh"
        }
    }



    onPageCreated: {
        console.log("NoteDb page created");
        console.log("ZeUi:"+ZeUi.ZBLib);


        /*set isDbReady flag*/
        if(objPage.isPasswordProtected){
            if(objPage.password === "")
            {
                objPage.isDbReady = false
                //TODO: show custom error message
            }
            else{
                objPage.isDbReady = objNoteManager.orm.isORMReady();
                if(!objPage.isDbReady)
                {
                    //TODO: show custom error message
                }
            }
        }
        else{
            objPage.isDbReady = objNoteManager.orm.isORMReady();
            if(!objPage.isDbReady)
            {
                //TODO: show custom error message
            }
        }


        if(objPage.isDbReady)
        {
            objPage.refresh();
        }
    }
    onPageClosing: {
        console.log("NoteDb page closing");
    }
    onPageOpened: {
        console.log("NoteDb page opened");
    }
    onPageHidden: {
        console.log("NoteDb page hidden");
    }
    onPageClosed: {
        console.log("NoteDb page closed");
    }

    /*Non Visual Core Items here*/
    NQBNoteManager{
        id: objNoteManager
        dbPath: objPage.path
        dbDriver: objPage.isPasswordProtected?"BEESD":"QSQLITE"
        password: objPage.password
        masterPassword: objPage.password
        masterPasswordIterationCount: 64000 /*Iteration count will be based on db version*/
    }

    /*all functions here*/
    function all()
    {
        objNoteManager.all();
    }

    function refresh()
    {
        objNoteManager.refresh();
    }


    /* Visual items here */
    NoteDBComp.NDbVSimpleNoteListView{
        id: objNoteListView
        anchors.fill: parent
    }


    /* All dialogs here */
    Comp.NQBAddNote{
        id: objAddNote
        anchors.fill: parent
        onButtonClicked: {
            if(objAddNote.isUpdate){
                if(objAddNote.isValid())
                {
                    var dmap = objAddNote.getDataMap();
                    var index = objNoteManager.noteQuery.indexOf("pk",dmap.pk);
                    if(index !==-1){
                        if(objNoteManager.noteQuery.update(index,dmap))
                        {
                            objAddNote.statusBarMessage = "Note updated";
                            objAddNote.close();
                        }
                    }
                    else{
                        objAddNote.statusBarMessage = "Invalid index";
                    }
                }
                else
                {
                    objAddNote.statusBarMessage = "Name and group is required";
                }
            }
            else{
                if(objAddNote.isValid())
                {
                    if(objNoteManager.noteQuery.add(objAddNote.getDataMap()))
                    {
                        objAddNote.statusBarMessage = "Note added";
                        objAddNote.close();
                    }
                }
                else
                {
                    objAddNote.statusBarMessage = "Name and group is required";
                }
            }
        }
    }
}
