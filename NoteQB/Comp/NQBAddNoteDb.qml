import Qb 1.0
import Qb.ORM 1.0
import Qb.Core 1.0

import QtQuick 2.10
import QtQml.Models 2.10
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "./../Core" as Core
import "./../Lang" as Lang
import "./../../ZeUi" as ZeUi


ZeUi.ZDialogUi2{
    id: objAddNoteDbDialog
    title: "Add Note Db"
    enableStatusBar: true
    statusBarButtonText: "ADD"
    topRadius: 0
    signal noteDbAdded();


    property string nameField;
    property string pathField;
    property string dbFormatField;

    onButtonClicked: {
        objAddNoteDbDialog.formatAndAddNoteDb();
    }

    onVisibleChanged:{
        if(visible){
            pathField = Core.NQBOne.lastPath;
        }
    }

    function resetFields(){
        nameField = "";
        dbFormatField = "";
        pathField = "";
        objAddNoteDbDialog.statusBarMessage = "";
    }

    function formatAndAddNoteDb(){
        if(nameField === ""){
            objAddNoteDbDialog.statusBarMessage = Lang.NQBLang.language.se1;
        }
        else if(pathField === ""){
            objAddNoteDbDialog.statusBarMessage = Lang.NQBLang.language.se2;
        }
        else{
            var dbpath = pathField+"/"+nameField+"."+String(dbFormatField).toLowerCase();
            if(QbUtil.isFileWritable(pathField)){
                if(!Core.NQBOne.isNoteDbExists(dbpath)){
                    if(Core.NQBOne.addNoteDb({"path":dbpath,"meta":{}}))
                    {
                        objAddNoteDbDialog.noteDbAdded();
                    }
                    else{
                        objAddNoteDbDialog.statusBarMessage = Lang.NQBLang.language.se3;
                    }
                }
                else{
                    objAddNoteDbDialog.statusBarMessage = Lang.NQBLang.language.se5;
                }
            }
            else{
                objAddNoteDbDialog.statusBarMessage = Lang.NQBLang.language.se4;
            }
        }
    }


    modelComponent: Component{
        ObjectModel{
            ZeUi.ZSpacer{
                width:objAddNoteDbDialog.dialogWidth
                height: 5
            }

            ZeUi.ZTextField {
                id: objNameField
                label: Lang.NQBLang.language.sf1
                labelWidth: 30
                borderWidth: 1
                width: objAddNoteDbDialog.dialogWidth
                onFieldTextChanged: {
                    objAddNoteDbDialog.nameField = fieldText;
                }
            }

            ZeUi.ZSpacer{
                width:objAddNoteDbDialog.dialogWidth
                height: 5
            }

            ZeUi.ZFolderField{
                id: objPathField
                label: Lang.NQBLang.language.sf2
                labelWidth: 30
                borderWidth: 1
                width: objAddNoteDbDialog.dialogWidth
                onFieldTextChanged:{
                    Core.NQBOne.lastPath = fieldText;
                    objAddNoteDbDialog.pathField = fieldText;
                }
                Component.onCompleted: {
                    fieldText = Core.NQBOne.lastPath;
                    if(fieldText === "")
                    {
                        if(Qt.platform.os === "android" || Qt.platform.os === "ios")
                        {
                            fieldText = QbUtil.documentsPath("NoteQB");
                        }
                        else
                        {
                            fieldText = QbUtil.documentsPath("NoteQB");
                        }
                    }
                }
            }

            ZeUi.ZSpacer{
                width:objAddNoteDbDialog.dialogWidth
                height: 5
            }

            ZeUi.ZComboBox {
                id: objDbFormat
                label: Lang.NQBLang.language.sf3
                labelWidth: 30
                borderWidth: 1
                width: objAddNoteDbDialog.dialogWidth
                comboBoxModel: QbORMUtil.isSQLDriverExists("BEESD")?["QDBN","QDBX"]:["QDBN"]
                onFieldTextChanged: {
                    objAddNoteDbDialog.dbFormatField = fieldText;
                }
            }
        }
    }
}
