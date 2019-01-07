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
        if(title !== "Groups")
        {
            if(objGroupList.visible)
            {
                objGroupList.closeMenu();
            }
        }

        //title
        if(title === "Add Note")
        {
            objAddNote.isUpdate = false;
            objAddNote.resetFields();
            var m2 = {};
            m2["group"] = objNoteManager.currentGroup;
            objAddNote.setDataMap(m2);
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
        else if(title === "Search")
        {
            if(objSearchDialog.visible)
            {
                objSearchDialog.closeSearchWindow();
            }
            else
            {
                objSearchDialog.openSearchWindow();
            }
        }
        else if(title === "Groups")
        {
            if(objGroupList.visible)
            {
                objGroupList.closeMenu();
            }
            else
            {
                objGroupList.openMenu(0,y);
            }
        }
        else if(title === "Close")
        {
            QbUtil.getAppObject(objPage.appId,"NQBOne").closeCurrentNoteDb();
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
            icon: "mf-search"
            title: "Search"
        }
        ListElement{
            icon: "mf-refresh"
            title: "Refresh"
        }
        ListElement{
            icon: "mf-settings"
            title: "Settings"
        }
        ListElement{
            icon: "mf-cancel"
            title: "Close"
        }
    }

    ZeUi.ZBListMenu{
        id: objGroupList
        title: "Groups"
        activeFocusOnTab: false

        onSelectedItem: {
            if(index === 0)
            {
                objNoteManager.currentGroup = "";
                refresh();
            }
            else
            {
                objNoteManager.currentGroup = title;
                refresh();
            }
            objGroupList.closeMenu();
        }
        menuItemModel: ListModel{
            id: objGroupListModel
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
                console.log("Password is empty");
                objErrorDialog.errorField = "Password can not be empty.";
                objErrorDialog.open();
            }
            else{
                objPage.isDbReady = objNoteManager.orm.isORMReady();
                if(!objPage.isDbReady)
                {
                    //TODO: show custom error message
                    console.log("ORM is not ready.");
                    objErrorDialog.errorField = "Wrong password.";
                    objErrorDialog.open();
                }
            }
        }
        else{
            objPage.isDbReady = objNoteManager.orm.isORMReady();
            if(!objPage.isDbReady)
            {
                //TODO: show custom error message
                console.log("ORM is not ready.");
                objErrorDialog.errorField = "Failed to open database.";
                objErrorDialog.open();
            }
        }


        if(objPage.isDbReady)
        {
            objPage.setGroupValueList(objNoteManager.getGroupList());
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

    function search(term)
    {
        objNoteManager.search(term);
    }

    function fullTextSearch(term)
    {
        objNoteManager.fullTextSearch(term);
    }

    function setGroupValueList(values)
    {
        objGroupListModel.clear();
        objGroupListModel.append({"title":"All"});
        if(values)
        {
            for(var i=0;i<values.length;++i)
            {
                objGroupListModel.append({"title":String(values[i])});
            }
        }
    }

    function taskAfterNoteAdd()
    {
        objPage.setGroupValueList(objNoteManager.getGroupList());
    }

    function taskAfterNoteUpdate()
    {
        taskAfterNoteAdd();
    }


    /* Visual items here */

    Rectangle{
        anchors.fill: parent
        color: "lightgrey"

        Item{
            id: objSearchBarPlaceHolder
            width: parent.width
            anchors.top: parent.top
            height: 0
        }

        NoteDBComp.NDbVSimpleNoteListView{
            id: objNoteListView
            clip: true
            anchors.top: objSearchBarPlaceHolder.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: objBottomBarPlaceHolder.top
            noteQueryModel.limit: objNoteManager.limit
        }

        Item{
            id: objBottomBarPlaceHolder
            width: parent.width
            height: 50
            anchors.bottom: parent.bottom

            Row{
                width: 100
                height: 50
                anchors.centerIn: parent
                ZeUi.ZMRoundButton{
                    text: QbMF3.icon("mf-navigate_before")
                    font.family: QbMF3.family
                    font.pixelSize: 20
                    width: 50
                    height: 50
                    enabled: objNoteManager.currentPage>1 && objPage.isDbReady
                    onClicked: {
                        objNoteManager.currentPage = objNoteManager.currentPage - 1;
                        objNoteManager.getPage(objNoteManager.currentPage);
                    }
                }

                ZeUi.ZMRoundButton{
                    text: QbMF3.icon("mf-navigate_next")
                    font.family: QbMF3.family
                    font.pixelSize: 20
                    width: 50
                    height: 50
                    enabled: objNoteManager.currentPage<objNoteListView.noteQueryModel.totalPages && objPage.isDbReady
                    onClicked: {
                        //console.log("CLICKED");
                        //console.log(objNoteListView.noteQueryModel.totalItems);
                        //console.log(objNoteListView.noteQueryModel.totalPages);
                        objNoteManager.currentPage = objNoteManager.currentPage + 1;
                        objNoteManager.getPage(objNoteManager.currentPage);
                    }
                }
            }

        }
    }



    /* All dialogs here */
    Comp.NQBSearchDialog{
        id: objSearchDialog
        anchors.fill: parent
        color: appUi.mCT("black",150)
        onSearchTermChanged:
        {
            objNoteManager.fullTextSearch(objSearchDialog.searchTerm);
        }
    }

    Comp.NQBErrorDialog{
        id: objErrorDialog
        anchors.fill: parent
    }

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
                            objPage.taskAfterNoteUpdate();
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
                        objPage.taskAfterNoteAdd();
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
