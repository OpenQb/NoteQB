import Qb 1.0
import Qb.Core 1.0
import Qb.ORM 1.0
import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

import "./../../../ZeUi" as ZeUi
import "./../../Core" as Core

Rectangle {

    property alias currentIndex: objNoteListView.currentIndex

    QbORMQueryModel{
        id: objNoteQueryModel
        query: objNoteManager.noteQuery
    }

    ListView{
        id: objNoteListView
        model: objNoteQueryModel
        anchors.fill: parent
        activeFocusOnTab: true
        currentIndex: -1

        delegate: Item{
            id: objDelegate
            width: objNoteListView.width
            height: 75
            property color itemBgColor: index%2?
                                            ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.primary)[0]:
                                            ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.secondary)[0]

            property color barColor: index%2?
                                         ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.primary)[6]:
                                         ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.secondary)[6]
            property color itemSelectedColor: ZeUi.ZBTheme.metaTheme.computeColorList(ZeUi.ZBTheme.metaTheme.accent)[9]
            property bool isSelected: objNoteListView.currentIndex === index

            Keys.onReturnPressed: {
                event.accepted = true;
                objNoteListView.currentIndex = index;
                Core.NQBOne.openNote(name,objNoteManager,pk,index);
            }
            Keys.onEnterPressed: {
                event.accepted = true;
                objNoteListView.currentIndex = index;
                Core.NQBOne.openNote(name,objNoteManager,pk,index);
            }
            Rectangle{
                id: objDelegateBackground
                anchors.fill: parent
                color: objDelegate.itemBgColor
                Rectangle{
                    width: 5
                    height: parent.height
                    color: objDelegate.isSelected //&& objDelegate.activeFocus
                           ?objDelegate.itemSelectedColor:objDelegate.barColor
                }
                Column{
                    id: objTextFields
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 5
                    property int totalItems: 3
                    Text{
                        width: parent.width
                        height: parent.height/objTextFields.totalItems
                        text: name
                        wrapMode: Text.NoWrap
                        elide: Text.ElideMiddle
                        color: ZeUi.ZBTheme.metaTheme.textColor(objDelegate.itemBgColor)
                        font.bold: true
                        font.family: height*0.70
                    }
                    Text{
                        width: parent.width
                        height: parent.height/objTextFields.totalItems
                        text: group
                        wrapMode: Text.NoWrap
                        elide: Text.ElideMiddle
                        font.family: height*0.70
                        color: ZeUi.ZBTheme.metaTheme.ilighter(ZeUi.ZBTheme.metaTheme.textColor(objDelegate.itemBgColor),50)
                    }
                    Text{
                        width: parent.width
                        height: parent.height/objTextFields.totalItems
                        text: QbUtil.stringJoin(tags,",")
                        wrapMode: Text.NoWrap
                        elide: Text.ElideRight
                        font.family: height*0.70
                        color: ZeUi.ZBTheme.metaTheme.ilighter(ZeUi.ZBTheme.metaTheme.textColor(objDelegate.itemBgColor),50)
                    }
                }//TextFields columns



                MouseArea{
                    id: objDelegateMouseArea
                    anchors.fill: parent
                    onPressed: {
                        objNoteListView.currentIndex = index;
                    }
                    onDoubleClicked: {
                        objNoteListView.currentIndex = index;
                        Core.NQBOne.openNote(name,objNoteManager,pk,index);
                    }
                    onPressAndHold: {
                        objNoteListView.currentIndex = index;
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
                                objNoteListView.currentIndex = index;
                                Core.NQBOne.openNote(name,objNoteManager,pk,index);
                            }
                        }
                        MenuItem {
                            text: "Close"
                            onTriggered: {
                                objNoteListView.currentIndex = index;
                                Core.NQBOne.closeNote(name,objNoteManager,pk,index);
                            }
                        }
                        MenuSeparator{}
                        MenuItem {
                            text: "Delete"
                            onTriggered: {
                                Core.NQBOne.deleteNote(name,objNoteManager,pk,index);
                            }
                        }
                    }
                }
            }
        }//delegate



    }
}
