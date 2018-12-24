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
    id: objNoteQBPage
    title: "NoteQB"
    contextDock: objContextDock


    onWidthChanged: {
        objNoteQBPage.state = ZeUi.ZBLib.getGridState(width);
    }
    onFocusChanged: {
        if(focus){
            objNoteDbListView.forceActiveFocus();
        }
    }
    activeFocusOnTab: true

    Keys.forwardTo: [objNoteDbListView,objNoteDbListViewPlaceHolder]


    states: [
        State {
            name: "xs"
            PropertyChanges {
                target: objNoteDbListViewPlaceHolder;
                width: objNoteQBPage.width
            }
            PropertyChanges {
                target: objNoteDbDetailsPlaceHolder;
                visible: false
            }
        },
        State {
            name: "sm"
            PropertyChanges {
                target: objNoteDbListViewPlaceHolder;
                width: 300
            }
            PropertyChanges {
                target: objNoteDbDetailsPlaceHolder;
                visible: true
            }
        }
        ,
        State {
            name: "md"
            PropertyChanges {
                target: objNoteDbListViewPlaceHolder;
                width: 300
            }
            PropertyChanges {
                target: objNoteDbDetailsPlaceHolder;
                visible: true
            }
        },
        State {
            name: "lg"
            PropertyChanges {
                target: objNoteDbListViewPlaceHolder;
                width: 300
            }
            PropertyChanges {
                target: objNoteDbDetailsPlaceHolder;
                visible: true
            }
        }
        ,
        State {
            name: "xl"
            PropertyChanges {
                target: objNoteDbListViewPlaceHolder;
                width: 300
            }
            PropertyChanges {
                target: objNoteDbDetailsPlaceHolder;
                visible: true
            }
        }
    ]

    onSelectedContextDockItem: {
        //title
        if(title === "Add"){
            objAddNoteDb.resetFields();
            objAddNoteDb.open();
        }
        else if(title === "Refresh")
        {
            refreshNoteDbListView();
        }
    }

    ListModel{
        id: objContextDock
        ListElement{
            icon: "mf-library_add"
            title: "Add"
        }
        ListElement{
            icon: "mf-refresh"
            title: "Refresh"
        }
    }

    QbORMQueryModel{
        id: objNoteDbQueryModel
        limit: 1000
        query: Core.NQBOne.noteDbModelORM.noteDbModelQuery
        onTotalItemsChanged: {
            console.log("Total items:"+totalItems);
        }
        onCountChanged: {
            console.log("Count:"+count);
        }
    }

    Connections{
        target: Core.NQBOne
        onRefresh:{
            refreshNoteDbListView();
        }
    }

    /* Page Contents here */
    Item{
        anchors.fill: parent
        Rectangle{
            id: objNoteDbListViewPlaceHolder
            color: "transparent"
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width
            height: parent.height

            Rectangle{
                id: objNotFoundText
                visible: objNoteDbQueryModel.count === 0
                anchors.fill: parent
                color: ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.primary)[0]
                Text{
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: "No Note Db found"
                    color: ZeUi.ZBTheme.metaTheme.idarker(parent.color,50)
                    font.pixelSize: 20
                }
            }

            ListView{
                id: objNoteDbListView
                width: parent.width - 2
                height: parent.height
                model: objNoteDbQueryModel
                activeFocusOnTab: true
                currentIndex: 0
                onActiveFocusChanged: {
                    if(activeFocus){
                        if(objNoteDbListView.currentItem){
                            objNoteDbListView.currentItem.forceActiveFocus();
                            objNoteDbListView.currentItem.focus = true;
                        }
                    }
                }
                onCurrentIndexChanged: {
                    if(objNoteDbListView.currentItem){
                        objNoteDbListView.currentItem.forceActiveFocus();
                        objNoteDbListView.currentItem.focus = true;
                    }
                }
                delegate: Item{
                    id: objDelegate
                    width: objNoteDbListView.width
                    height: 75
                    property color itemBgColor: index%2?
                                                    ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.primary)[0]:
                                                    ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.secondary)[0]

                    property color barColor: index%2?
                                                 ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.primary)[6]:
                                                 ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.secondary)[6]
                    property color itemSelectedColor: ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.accent)[9]
                    property bool isSelected: objNoteDbListView.currentIndex === index

                    Keys.onReturnPressed: {
                        event.accepted = true;
                        StudioQBCore.StudioQBOne.openProject(pid,name,source_dir,output_dir,export_format,json);
                    }
                    Keys.onEnterPressed: {
                        event.accepted = true;
                        StudioQBCore.StudioQBOne.openProject(pid,name,source_dir,output_dir,export_format,json);
                    }
                    Rectangle{
                        id: objDelegateBackground
                        anchors.fill: parent
                        color: objDelegate.itemBgColor
                        Rectangle{
                            width: 5
                            height: parent.height
                            color: objDelegate.isSelected && objDelegate.activeFocus?objDelegate.itemSelectedColor:objDelegate.barColor
                        }
                        Column{
                            id: objTextFields
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 5
                            property int totalItems: 2
                            Text{
                                width: parent.width
                                height: parent.height/objTextFields.totalItems
                                text: QbUtil.fileNameWithoutExtFromPath(path)
                                wrapMode: Text.NoWrap
                                elide: Text.ElideMiddle
                                color: ZeUi.ZBTheme.metaTheme.textColor(objDelegate.itemBgColor)
                                font.bold: true
                                font.family: height*0.70
                            }
                            Text{
                                width: parent.width
                                height: parent.height/objTextFields.totalItems
                                text: path
                                wrapMode: Text.NoWrap
                                elide: Text.ElideMiddle
                                font.family: height*0.70
                                color: ZeUi.ZBTheme.metaTheme.ilighter(ZeUi.ZBTheme.metaTheme.textColor(objDelegate.itemBgColor),50)
                            }

                            //                            Item{
                            //                                width: parent.width
                            //                                height: parent.height/3.0
                            //                                Text{
                            //                                    width: 50
                            //                                    height: parent.height
                            //                                    anchors.right: parent.right
                            //                                    text: QbUtil.fileSizeText(path)
                            //                                    wrapMode: Text.NoWrap
                            //                                    elide: Text.ElideMiddle
                            //                                    font.family: height*0.70
                            //                                    color: ZeUi.ZBTheme.metaTheme.ilighter(ZeUi.ZBTheme.metaTheme.textColor(objDelegate.itemBgColor),50)
                            //                                }
                            //                            }


                        }//TextFields columns



                        MouseArea{
                            id: objDelegateMouseArea
                            anchors.fill: parent
                            onPressed: {
                                objNoteDbListView.currentIndex = index;
                            }
                            onDoubleClicked: {
                                objNoteDbListView.currentIndex = index;
                                Core.NQBOne.openNoteDb(path);
                            }
                            onPressAndHold: {
                                objNoteDbListView.currentIndex = index;
                            }
                        }

                        Button{
                            id: objDelegateMenuButton
                            anchors.top: parent.top
                            anchors.right: parent.right
                            text: QbMF3.icon("mf-more_vert")
                            font.family: QbMF3.family
                            font.pixelSize: height*0.80
                            height: 30
                            width: 30
                            Material.theme: Material.Light
                            contentItem: Text {
                                text: objDelegateMenuButton.text
                                font: objDelegateMenuButton.font
                                opacity: enabled ? 1.0 : 0.3
                                color: ZeUi.ZBTheme.metaTheme.textColor(objDelegate.itemBgColor)
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                color: objDelegateMenuButton.down?ZeUi.ZBTheme.metaTheme.primary:"transparent"
                            }
                            onClicked: {
                                objDelegateMenu.open();
                            }
                            Menu {
                                id: objDelegateMenu
                                y: objDelegateMenuButton.height
                                onClosed: {
                                    objDelegate.forceActiveFocus();
                                    objDelegate.focus = true;
                                }
                                MenuItem {
                                    text: "Open"
                                    onTriggered: {
                                        Core.NQBOne.openNoteDb(path);
                                    }
                                }
                                MenuItem {
                                    text: "Close"
                                    onTriggered: {
                                        Core.NQBOne.closeNoteDb(path);
                                    }
                                }
                                MenuSeparator{}
                                MenuItem {
                                    text: "Remove"
                                    onTriggered: {
                                        Core.NQBOne.removeNoteDb(path)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Rectangle{
                width: 2
                height: parent.height
                anchors.right: parent.right
                color: ZeUi.ZBTheme.metaTheme.idarker(ZeUi.ZBTheme.metaTheme.accent,50)
            }
        }

        Rectangle{
            id: objNoteDbDetailsPlaceHolder
            color: "lightgrey"
            anchors.top: parent.top
            anchors.right: parent.right
            height: parent.height
            width: parent.width - objNoteDbListViewPlaceHolder.width
        }
    }



    /* All Dialogs will be here*/
    Comp.NQBAddNoteDb{
        id: objAddNoteDb
        anchors.fill: parent
        onNoteDbAdded: {
            objAddNoteDb.close();
        }
    }
    /* end dialog space*/

    function refreshNoteDbListView(){
        objNoteDbQueryModel.search(["path","meta"]);
    }

    onPageCreated: {
        objNoteQBPage.state = "xs";
        refreshNoteDbListView();
    }
}
