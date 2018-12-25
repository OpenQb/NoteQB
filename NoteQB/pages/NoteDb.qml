import Qb 1.0
import Qb.ORM 1.0
import Qb.Core 1.0

import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../../ZeUi" as ZeUi
import "./../Core" as Core
import "./../Comp" as Comp

ZeUi.ZSOneAppPage{
    id: objPage
    title: "Note Db"

    property string path: "";
    property string password: "";

    property bool isPasswordProtected: false;
    property bool isDbReady: false;
    property int dbVersion: 1


    onPageCreated: {
        console.log("NoteDb page created");


        /*set isDbReady flag*/
        if(objPage.isPasswordProtected){
            if(objPage.password === "")
            {
                objPage.isDbReady = false
                //TODO: show custom error message
            }
            else{
                objPage.isDbReady = objOrm.isORMReady();
                if(!objPage.isDbReady)
                {
                    //TODO: show custom error message
                }
            }
        }
        else{
            objPage.isDbReady = objOrm.isORMReady();
            if(!objPage.isDbReady)
            {
                //TODO: show custom error message
            }
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
    Core.NQBNoteManager{
        dbPath: objPage.path
        dbDriver: objPage.isPasswordProtected?"BEESD":"QSQLITE"
        password: objPage.password
        masterPassword: objPage.password
        masterPasswordIterationCount:  64000/*Iteration count will be based on db version*/
    }

    /*all functions here*/

    /*Visual items here*/
    Rectangle{
        anchors.fill: parent
    }

}
