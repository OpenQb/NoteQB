import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../../ZeUi" as ZeUi
import "./../Comp" as Comp
import "./../Core" as Core
import "./../Models" as Models

ZeUi.ZPage{
    id: objPage
    title: "Note View"

    property variant pk: null;
    property QtObject noteFile: null
    property var noteManager: null
    contextDock: objContextDock

    onNoteFileChanged: {
        if(noteFile)
        {
            noteFile.one();
            objTextEdit.text = noteFile.note;
        }
    }

    onPageClosing: {
        if(noteManager)
        {
            if(noteFile) noteManager.releaseNoteFile(noteFile);
        }
    }
    onPageCreated: {
        if(noteManager)
        {
            if(pk)
            {
                if(noteManager.isNoteFileExists(pk))
                {
                    noteFile = noteManager.getNoteFile(pk);
                }
                else
                {
                    noteFile = noteManager.createNoteFile(pk);
                }
            }
        }
    }

    onSelectedContextDockItem: {
        //title
        if(title === "Close")
        {
            QbUtil.getObject("com.cliodin.qb.NoteQB.NQBOne").closeCurrentNote();
        }
        else if(title === "Save")
        {
            if(noteFile)
            {
                noteFile.update();
            }
        }
    }

    ListModel{
        id: objContextDock
        ListElement{
            icon: "mf-save"
            title: "Save"
        }
        ListElement{
            icon: "mf-cancel"
            title: "Close"
        }
        ListElement{
            icon: "mf-refresh"
            title: "Refresh"
        }
    }


    Rectangle{
        anchors.fill: parent

        TextEdit{
            id: objTextEdit
            anchors.fill: parent
            onTextChanged: {
                if(noteFile)
                {
                    noteFile.note = text;
                }
            }
        }


    }
}
