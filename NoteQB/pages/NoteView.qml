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
    property bool isSaving: false


    contextDock: objContextDock

    //Keys.forwardTo: [objFlickArea,objTextEdit]
    onIsSavingChanged: {
        if(isSaving)
        {
            objContextDock.append({"icon":"mf-loop","title":"Saving"});
        }
        else
        {
            objContextDock.remove(objContextDock.count - 1);
        }
    }
    onIsNoteChangedChanged: {
        if(isNoteChanged)
        {
            objContextDock.get(1).icon_rotation = 0;
            objSaveRotation.start();
        }
        else
        {
            objSaveRotation.stop();
            objContextDock.get(1).icon_rotation = 0;
        }
    }

    QtObject{
        id: objNoteMeta
        property bool isAutoSave: false
        property bool showLineNumbers: true
        property int fontSize: 10
    }

    Timer{
        id: objSaveRotation
        interval: 20
        repeat: true
        running: false
        onTriggered: {
            var r = objContextDock.get(1).icon_rotation+1;
            objContextDock.get(1).icon_rotation = r;
        }
    }

    Timer{
        id: objTimer
        interval: 500

        repeat: false
        running: false
        onTriggered: {
            objTimer.stop();
            noteFile.one();
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
                    objPage.isSaving = true;
                    if(noteFile.update())
                    {
                        objPage.isNoteChanged = false;
                        objPage.isSaving = false;
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
            icon_rotation: 0
        }
        ListElement{
            icon: "mf-cancel"
            title: "Close"
        }
    }


    Keys.onPressed: {
        event.accepted = true;
        //console.log(event);
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
            if(objPage.isNoteChanged)
            {
                objPage.isSaving = true;
                if(objPage.noteFile.update())
                {
                    objPage.isNoteChanged = false;
                    objPage.isSaving = false;
                }
            }
        }
    }
    Keys.onReleased: {
        event.accepted = true;
        //console.log(event);
    }

    Keys.onEscapePressed: {
        event.accepted = true;
        QbUtil.getAppObject(objPage.appId,"appUi").dockView.forceActiveFocus();
    }

    Keys.onTabPressed: {
        //console.log("TAB");
        event.accepted = true;
        if(objPage.isReadOnly){
            QbUtil.getAppObject(objPage.appId,"appUi").dockView.forceActiveFocus();
        }
        else{
            objTextViewer.textEditItem.forceActiveFocus();
        }
    }


    Rectangle {
        anchors.fill: parent
        Comp.NQBTextViewer {
            id: objTextViewer

            Material.background: ZeUi.ZBTheme.background
            Material.accent: ZeUi.ZBTheme.accent
            Material.theme: Material.Light

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top

            readOnly: objPage.isReadOnly

            onTextChanged: {
                if(noteFile)
                {
                    noteFile.note = text;
                }
                objPage.isNoteChanged = true;
            }
        }

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
