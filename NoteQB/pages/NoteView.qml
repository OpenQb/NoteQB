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
    property var noteManager: null;
    property QtObject noteFile: null;
    property QtObject noteMeta: null;

    property bool isReadOnly: true;
    property bool isNoteChanged: false;
    property bool showLoadingScreen: objTimer.running;


    contextDock: objContextDock

    //Keys.forwardTo: [objFlickArea,objTextEdit]

    QtObject{
        id: objNoteMeta
        property bool isAutoSave: false
        property bool showLineNumbers: true
        property int fontSize: 10
    }

    Timer{
        id: objTimer
        interval: 500

        repeat: false
        running: false
        onTriggered: {
            objTimer.stop();
            objTextViewer.text = noteFile.note;
            objPage.isNoteChanged = false;
        }
    }

    onIsReadOnlyChanged: {
        if(isReadOnly)
        {
            objContextDock.get(0).icon = "mf-lock";
            objContextDock.get(0).title = "Locked";
        }
        else
        {
            objContextDock.get(0).icon = "mf-lock_open";
            objContextDock.get(0).title = "Unlocked";
            objTextViewer.textEditItem.forceActiveFocus();
        }
    }

//    onNoteFileChanged: {
//        if(noteFile)
//        {
//            noteFile.one();
//            objTextViewer.text = noteFile.note;
//        }
//    }

    onPageClosing: {
        if(noteManager)
        {
            if(noteFile)
            {
                if(objNoteMeta.isAutoSave)
                {
                    noteFile.update();
                }
                noteManager.releaseNoteFile(noteFile);
            }


            if(noteMeta)
            {
                noteMeta.meta = QbUtil.objectToMap(objNoteMeta);
                noteMeta.update();
                noteManager.releaseNoteMeta(noteMeta);
            }

        }
    }

    onPageCreated: {
        console.log("NoteView page created.");
        if(noteManager)
        {
            if(pk)
            {
                noteMeta = noteManager.getNoteMeta(pk);
                QbUtil.setMapToObject(noteMeta.meta,objNoteMeta);

                if(noteManager.isNoteFileExists(pk))
                {
                    noteFile = noteManager.getNoteFile(pk);
                    noteFile.one();
                    //objPage.showLoadingScreen = true;
                    //objTextViewer.text = noteFile.note;
                    objTimer.start();
                }
                else
                {
                    noteFile = noteManager.createNoteFile(pk);
                }
            }
        }
        objPage.isNoteChanged = false;
    }

    onSelectedContextDockItem: {
        //title
        if(title === "Close")
        {
            QbUtil.getAppObject(objPage.appId,"NQBOne").closeCurrentNote();
        }
        else if(title === "Locked" || title === "Unlocked")
        {
            objPage.isReadOnly = !objPage.isReadOnly;
        }
        else if(title === "Save")
        {
            if(noteFile)
            {
                if(objPage.isNoteChanged)
                {
                    if(noteFile.update())
                    {
                        objPage.isNoteChanged = false;
                    }
                }
            }
        }
    }

    ListModel{
        id: objContextDock
        ListElement{
            icon: "mf-lock"
            title: "Locked"
        }
        ListElement{
            icon: "mf-save"
            title: "Save"
        }
        ListElement{
            icon: "mf-cancel"
            title: "Close"
        }
    }


    Keys.onPressed: {
        event.accepted = true;
        console.log(event);
        if(event.key === Qt.Key_Down)
        {
            objTextViewer.scrollBarItem.increase();
        }
        else if(event.key === Qt.Key_Up)
        {
            objTextViewer.scrollBarItem.decrease();
        }
        else if ((event.key === Qt.Key_S) && (event.modifiers & Qt.ControlModifier))
        {
            objPage.noteFile.update();
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
        objTextViewer.textEditItem.forceActiveFocus();
    }


    Rectangle{
        anchors.fill: parent
        Comp.NQBTextViewer{
            id: objTextViewer
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            readOnly: objPage.isReadOnly
            Material.background: ZeUi.ZBTheme.background
            Material.accent: ZeUi.ZBTheme.accent
            Material.theme: Material.Light
            onTextChanged: {
                if(noteFile)
                {
                    noteFile.note = text;
                }
                objPage.isNoteChanged = true;
            }
        }



        //        Flickable {
        //            id: objFlickArea
        //            anchors.fill: parent
        //            contentWidth: parent.width
        //            contentHeight: objTextEdit.paintedHeight
        //            clip: true
        //            Material.background: ZeUi.ZBTheme.background
        //            Material.accent: ZeUi.ZBTheme.accent
        //            Material.theme: Material.Light

        //            ScrollBar.vertical: ScrollBar {
        //                id: objScrollBar
        //            }

        //            function ensureVisible(cursor)
        //            {
        //                if (objTextEdit.currentLine === 1)
        //                    contentY = 0
        //                else if (objTextEdit.currentLine === objTextEdit.lineCount && objFlickArea.visibleArea.heightRatio < 1)
        //                    contentY = contentHeight - height
        //                else
        //                {
        //                    if (contentY >= cursor.y)
        //                        contentY = cursor.y
        //                    else if (contentY + height <= cursor.y + cursor.height)
        //                        contentY = cursor.y + cursor.height - height
        //                }
        //            }

        //            TextEdit {
        //                id: objTextEdit
        //                width: objFlickArea.width
        //                readOnly: objPage.isReadOnly
        //                wrapMode: TextEdit.Wrap
        //                onCursorRectangleChanged: objFlickArea.ensureVisible(cursorRectangle)
        //                activeFocusOnPress: false
        //                textFormat: TextEdit.PlainText
        //                inputMethodHints: TextEdit.ImhNoPredictiveText

        //                property int currentLine: cursorRectangle.y / cursorRectangle.height + 1

        //                onTextChanged: {
        //                    if(noteFile)
        //                    {
        //                        noteFile.note = text;
        //                    }
        //                    objPage.isNoteChanged = true;
        //                }
        //            }
        //        }//Flickable

        //        MouseArea{
        //            anchors.fill: parent
        //            acceptedButtons: Qt.LeftButton | Qt.RightButton
        //            preventStealing: true
        //            onClicked: {
        //                //console.log("Clicked:");
        //                if(!objPage.isReadOnly)
        //                {
        //                    var startPosition = objTextEdit.positionAt(mouse.x, mouse.y);
        //                    console.log("Start pos:"+startPosition);
        //                    //console.log("Length:"+objTextField.text.length);
        //                    if(objTextEdit.text.length === 0)
        //                    {
        //                        objTextEdit.cursorPosition = 0;
        //                    }
        //                    else
        //                    {
        //                        if(startPosition<objTextEdit.text.length)
        //                        {
        //                            objTextEdit.cursorPosition = startPosition;
        //                        }
        //                        else
        //                        {
        //                            objTextEdit.cursorPosition = objTextEdit.text.length;
        //                        }
        //                    }

        //                }

        //                objTextEdit.focus = false;
        //                objTextEdit.forceActiveFocus();
        //                if (mouse.button === Qt.RightButton)
        //                {

        //                }
        //            }
        //            onPressed: {
        //                //console.log("Pressed:");
        //                if(!objPage.isReadOnly)
        //                {
        //                    var startPosition = objTextEdit.positionAt(mouse.x, mouse.y);
        //                    if(startPosition<objTextEdit.text.length) objTextEdit.cursorPosition = startPosition;
        //                    else objTextEdit.cursorPosition = objTextEdit.text.length;
        //                }

        //                objTextEdit.forceActiveFocus();
        //            }
        //        }//MouseArea


    }//Rectangle



    Rectangle{
        visible: objPage.showLoadingScreen
        anchors.fill: parent
        color: objPage.appUi.mCT("black",150)
        Text{
            id: objBusyIndicator
            width: 30
            height: 30
            anchors.right: parent.right
            anchors.top: parent.top
            text: QbFA.icon("fa-spinner")
            color: objPage.appUi.zBaseTheme.metaTheme.textColor(objPage.appUi.zBaseTheme.metaTheme.primary)
            font.pixelSize: 20
            font.family: QbFA.family
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            visible: objPage.showLoadingScreen
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
                direction: RotationAnimation.Clockwise
                duration: 1000
            }
        }

        MouseArea{
            anchors.fill: parent
            preventStealing: true
            onClicked: {
            }
            onDoubleClicked: {
            }
            onPressed: {
            }
        }
    }

}
