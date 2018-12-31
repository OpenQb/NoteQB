import Qb 1.0
import Qb.ORM 1.0
import Qb.Core 1.0

import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../../ZeUi" as ZeUi
import "./../Comp" as Comp


ZeUi.ZPage{
    id: objPage
    title: "Note View"

    property variant pk: null;
    property QtObject noteFile: null
    property var noteManager: null

    contextDock: objContextDock

    //Keys.forwardTo: [objFlickArea,objTextEdit]

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
        console.log("NoteView page created.");
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
            QbUtil.getAppObject(objPage.appId,"NQBOne").closeCurrentNote();
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
//        ListElement{
//            icon: "mf-refresh"
//            title: "Refresh"
//        }
    }


    Keys.onPressed: {
        event.accepted = true;
        console.log(event);
        if(event.key === Qt.Key_Down)
        {
            objScrollBar.increase();
        }
        else if(event.key === Qt.Key_Up)
        {
            objScrollBar.decrease();
        }
    }
    Keys.onReleased: {
        event.accepted = true;
        console.log(event);
    }

    Keys.onEscapePressed: {
        event.accepted = true;
        QbUtil.getAppObject(objPage.appId,"appUi").dockView.forceActiveFocus();
    }

    Keys.onTabPressed: {
        objTextEdit.forceActiveFocus();
    }


    Rectangle{
        anchors.fill: parent



        Flickable {
            id: objFlickArea
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: objTextEdit.paintedHeight
            clip: true
            Material.background: ZeUi.ZBTheme.background
            Material.accent: ZeUi.ZBTheme.accent
            Material.theme: Material.Light

            ScrollBar.vertical: ScrollBar {
              id: objScrollBar
            }

            function ensureVisible(r)
            {
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX+width <= r.x+r.width)
                    contentX = r.x+r.width-width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY+height <= r.y+r.height)
                    contentY = r.y+r.height-height;
            }

            TextEdit {
                id: objTextEdit
                width: objFlickArea.width
                wrapMode: TextEdit.Wrap
                onCursorRectangleChanged: objFlickArea.ensureVisible(cursorRectangle)
                activeFocusOnPress: false
                textFormat: TextEdit.PlainText
                inputMethodHints: TextEdit.ImhNoPredictiveText

                onTextChanged: {
                    if(noteFile)
                    {
                        noteFile.note = text;
                    }
                }
            }
        }//Flickable

        MouseArea{
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            preventStealing: true
            onClicked: {
                //console.log("Clicked:");
                var startPosition = objTextEdit.positionAt(mouse.x, mouse.y);
                //console.log("Start pos:"+startPosition);
                //console.log("Length:"+objTextField.text.length);
                if(objTextEdit.text.length === 0)
                {
                    objTextEdit.cursorPosition = 0;
                }
                else
                {
                    objTextEdit.cursorPosition = startPosition;
                }
                objTextEdit.focus = false;
                objTextEdit.forceActiveFocus();
                if (mouse.button === Qt.RightButton)
                {

                }
            }
            onPressed: {
                //console.log("Pressed:");
                var startPosition = objTextEdit.positionAt(mouse.x, mouse.y);
                if(startPosition>objTextEdit.text.length) objTextEdit.cursorPosition = startPosition;
                else objTextEdit.cursorPosition = objTextEdit.text.length;
                objTextEdit.forceActiveFocus();
            }
        }//MouseArea


    }
}
