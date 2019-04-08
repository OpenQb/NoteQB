import QtQuick 2.10
import QtQml.Models 2.10
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "./../../ZeUi/ui"

ZDialogPopupUi{
    id: objPopup
    modelComponent: Component{
        ObjectModel{

            ZSpacer{
                width:objPopup.dialogWidth
                height: 5
            }

            ZTextField {
                label: "Password"
                labelWidth: 30
                borderWidth: 1
                width: objPopup.dialogWidth
                textInputItem.inputMethodHints: Qt.ImhHiddenText|Qt.ImhSensitiveData
                textInputItem.echoMode: TextInput.Password
                onFieldTextChanged: {
                }
            }
        }
    }
}

//import Qb 1.0
//import Qb.Core 1.0
//import QtQuick 2.10
//import QtQml.Models 2.1
//import QtQuick.Controls 2.4
//import QtQuick.Controls.Material 2.4

//import "./../../ZeUi/base"

//Popup {
//    id: objPopup

//    modal: true
//    focus: true
//    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

//    topPadding: 0
//    bottomPadding: 0
//    leftPadding: 0
//    rightPadding: 0

//    property int dialogLeftMargin: 0
//    property int dialogRightMargin: 0
//    property int dialogTopMargin: 0
//    property int dialogBottomMargin: 0
//    property int dialogSpacing: 10
//    property int dialogTopRadius: 5

//    property bool dialogInteractive: true;

//    property string title: "Dialog"

//    property bool enableStatusBar: false;
//    property int dialogWidth: parent.width
//    property int dialogHeight: parent.height
//    property int availableDialogHeight: enableStatusBar?dialogHeight - 50*2:dialogHeight - 50*1


//    property string statusBarButtonText: "OK";
//    property string statusBarMessage: "";
//    property color statusBarMessageColor: "white";

//    signal buttonClicked();

//    property Item mainView: null
//    property ObjectModel model:null
//    property Component modelComponent: null

//    property Item dialogView: null
//    property int currentIndex:-1

//    onStatusBarMessageChanged: {
//        if(statusBarMessage !== ""){
//            if(objStatusBarClearTimer.running) objStatusBarClearTimer.stop();
//            objStatusBarClearTimer.start();
//        }
//    }

//    contentItem: Rectangle{
//        id: objDialogRoot

//        Connections{
//            target: ZBLib.appUi
//            onAppClosing:{
//                objPopup.close();
//            }
//        }

//        Timer{
//            id: objStatusBarClearTimer
//            interval: 5000
//            onTriggered: {
//                objPopup.statusBarMessage = ""
//                objStatusBarClearTimer.stop();
//            }
//        }



//        Component{
//            id: compDialog
//            Item{
//                id: objDialog
//                width: objDialogRoot.dialogWidth
//                height: objDialogRoot.dialogHeight
//                anchors.centerIn: parent

//                Rectangle{
//                    anchors.fill: parent
//                    color: ZBLib.appUi.zBaseTheme.background

//                    Rectangle{
//                        id: objTopBar
//                        anchors.top: parent.top
//                        anchors.left: parent.left
//                        anchors.right: parent.right
//                        height: 50
//                        color: ZBLib.appUi.zBaseTheme.primary
//                        Rectangle{
//                            width: parent.width
//                            height: 5
//                            color: ZBLib.appUi.zBaseTheme.primary
//                            anchors.bottom: parent.bottom
//                        }
//                        Text{
//                            id: objTitle
//                            anchors.left: parent.left
//                            anchors.right: parent.right
//                            anchors.top: parent.top
//                            anchors.bottom: parent.bottom
//                            horizontalAlignment: Text.AlignHCenter
//                            verticalAlignment: Text.AlignVCenter
//                            text: objPopup.title
//                            font.family: ZBLib.appUi.zBaseTheme.defaultFontFamily
//                            font.pixelSize: ZBLib.appUi.zBaseTheme.defaultFontSize+3
//                            color: ZBLib.appUi.zBaseTheme.metaTheme.isDark(ZBLib.appUi.zBaseTheme.primary)?"white":"black"
//                        }
//                        Item{
//                            id: objCloseButton
//                            anchors.right: parent.right
//                            anchors.top: parent.top
//                            height: parent.height
//                            width: height
//                            Rectangle{
//                                id: objCloseButtonBG
//                                anchors.centerIn: parent
//                                height: parent.height*0.60
//                                width: parent.width*0.60
//                                radius: height/2.0
//                                activeFocusOnTab: true
//                                property bool isHovered: false
//                                color: isHovered?ZBLib.appUi.zBaseTheme.metaTheme.lighter(ZBLib.appUi.zBaseTheme.accent,180):focus?ZBLib.appUi.zBaseTheme.metaTheme.lighter(ZBLib.appUi.zBaseTheme.accent,180):ZBLib.appUi.zBaseTheme.accent
//                                Keys.onPressed: {
//                                    if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return || event.key === Qt.Key_Space){
//                                        event.accepted = true;
//                                        objPopup.close();
//                                    }
//                                }
//                                Keys.onReleased: {
//                                    event.accepted = true;
//                                }

//                                Text{
//                                    anchors.fill: parent
//                                    horizontalAlignment: Text.AlignHCenter
//                                    verticalAlignment: Text.AlignVCenter
//                                    font.family: QbMF3.family
//                                    text: QbMF3.icon("mf-close")
//                                    font.pixelSize: parent.height/2
//                                    color: ZBLib.appUi.zBaseTheme.metaTheme.isDark(ZBLib.appUi.zBaseTheme.accent)?"white":"black"
//                                }
//                                MouseArea{
//                                    anchors.fill: parent
//                                    hoverEnabled: true;
//                                    onEntered: {
//                                        objCloseButtonBG.isHovered = true;
//                                    }
//                                    onExited: {
//                                        objCloseButtonBG.isHovered = false;
//                                    }
//                                    onClicked: {
//                                        objPopup.close();
//                                    }
//                                }
//                            }
//                        }
//                    }//end of TopBar

//                    ListView{
//                        id: objListView
//                        clip: true

//                        anchors.left: parent.left
//                        anchors.leftMargin: objPopup.dialogLeftMargin
//                        anchors.right: parent.right
//                        anchors.rightMargin: objPopup.dialogRightMargin
//                        anchors.top: objTopBar.bottom
//                        anchors.topMargin: objPopup.dialogTopMargin
//                        anchors.bottom: objStatusBar.top
//                        anchors.bottomMargin: objPopup.dialogBottomMargin
//                        interactive: objPopup.interactive
//                        model: objPopup.model
//                        activeFocusOnTab: true
//                        highlightFollowsCurrentItem: true
//                        currentIndex: 0
//                        //onCurrentIndexChanged: objDialogRoot.currentIndex = objListView.currentIndex;
//                        ScrollBar.vertical: ScrollBar {
//                            id: objScrollBar;
//                            active: objScrollBar.focus || objListView.focus
//                            focusReason: Qt.StrongFocus
//                            Keys.onUpPressed: objScrollBar.decrease()
//                            Keys.onDownPressed: objScrollBar.increase()
//                        }
//                        Material.accent: ZBLib.appUi.zBaseTheme.accent
//                        Material.primary: ZBLib.appUi.zBaseTheme.primary
//                        Material.foreground: ZBLib.appUi.zBaseTheme.foreground
//                        Material.background: ZBLib.appUi.zBaseTheme.background
//                        Component.onCompleted: {
//                            objPopup.dialogView = objListView;
//                        }

//                        function actionUpPressed(event){
//                            if(objListView.currentIndex === 0){
//                                event.accepted = false;
//                                return;
//                            }

//                            while(true){
//                                objListView.decrementCurrentIndex();
//                                if(objListView.currentIndex === 0){
//                                    break;
//                                }
//                                if(objListView.currentItem.visible === true && objListView.currentItem.enabled === true){
//                                    break;
//                                }
//                            }
//                        }

//                        function actionDownPressed(event){
//                            if(objListView.currentIndex >= (objListView.count-1)){
//                                event.accepted = false;
//                                return;
//                            }
//                            while(true){
//                                objListView.incrementCurrentIndex();
//                                if(objListView.currentIndex >=(objListView.count-1)){
//                                    break;
//                                }
//                                if(objListView.currentItem.visible === true && objListView.currentItem.enabled === true){
//                                    break;
//                                }
//                            }
//                        }
//                        Keys.onUpPressed: actionUpPressed(event)
//                        Keys.onDownPressed: actionDownPressed(event)
//                    }//End of ListView

//                    //StatusBar
//                    Rectangle{
//                        id: objStatusBar
//                        anchors.bottom: parent.bottom
//                        visible: objPopup.enableStatusBar
//                        width: parent.width
//                        height: objPopup.enableStatusBar?QbCoreOne.scale(50):0
//                        color: ZBTheme.primary
//                        Label{
//                            anchors.left: parent.left
//                            anchors.leftMargin: QbCoreOne.scale(5)
//                            anchors.right: objOKButton.left
//                            anchors.rightMargin: QbCoreOne.scale(5)
//                            anchors.bottom: parent.bottom
//                            anchors.top: parent.top
//                            text: objPopup.statusBarMessage
//                            color: objPopup.statusBarMessageColor
//                            elide: Label.ElideMiddle
//                            verticalAlignment: Label.AlignVCenter
//                            //horizontalAlignment: Label.AlignHCenter
//                        }
//                        Button{
//                            id: objOKButton
//                            Material.background: ZBTheme.secondary
//                            Material.theme: Material.Light
//                            text: objPopup.statusBarButtonText
//                            anchors.right: parent.right
//                            anchors.rightMargin: QbCoreOne.scale(5)
//                            onClicked: {
//                                objPopup.buttonClicked();
//                            }
//                            Rectangle{
//                                visible: objOKButton.activeFocus
//                                anchors.bottom: parent.bottom
//                                anchors.left: parent.left
//                                anchors.right: parent.right
//                                height: QbCoreOne.scale(2)
//                                color: ZBTheme.accent
//                            }
//                        }
//                    }
//                }
//            }
//        }//Component




//    }//contentItem


//    function closeDialog(){
//        if(objPopup .mainView){
//            try{objPopup.mainView.destroy();}catch(e){}
//        }
//        if(objPopup.model){
//            try{objPopup.model.destroy();}catch(e){}
//        }
//        objPopup.mainView = null;
//        objPopup.close();
//    }

//    function openDialog(){
//        console.log("ZBLIb",ZBLib.appUi);
//        if(objPopup.mainView === null && ZBLib.appUi && objPopup.model === null)
//        {
//            console.log("Opening dialog.");
//            objPopup.model = objPopup.modelComponent.createObject(objDialogRoot,{});
//            objPopup.mainView = compDialog.createObject(objDialogRoot,{});
//            objPopup.open();
//        }
//    }
//}
