import Qb 1.0
import Qb.Core 1.0

import QtQuick 2.10
import QtQml.Models 2.10
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "./../Core" as Core
import "./../Lang" as Lang
import "./../../ZeUi" as ZeUi


ZeUi.ZDialogUi2{
    id: objAddDialog
    title: isUpdate?"Update Note":"Add Note"
    enableStatusBar: true
    statusBarButtonText: isUpdate?"UPDATE":"ADD"
    topRadius: 0
    property bool isUpdate:false;

    property string pkField;
    property string nameField;
    property string groupField;
    property string tagsField;

    function resetFields(){
        nameField = "";
        groupField = "";
        tagsField = "";
    }

    function getDataMap(){
        var m = {};
        if(isUpdate) m["pk"] = pkField;
        m["name"] = nameField;
        m["group"] = groupField;
        m["tags"] = QbUtil.stringTokenList(tagsField,',');
        m["status"] = 0;
        m["reminder"] = 0;
        return m;
    }

    function setDataMap(m){
        //console.log(m.group);
        if(m.pk){
            pkField = m["pk"];
        }
        if(m.name){
            nameField = m["name"];
        }
        if(m.group){
            groupField = String(m["group"]);
        }
        if(m.tags){
            tagsField = QbUtil.stringJoin(m["tags"],",");
        }
    }

    function isValid(){
        if(nameField !== "" & groupField !== "") return true;
        else return false;
    }

    modelComponent: Component{
        ObjectModel{

            ZeUi.ZSpacer{
                width:objAddDialog.dialogWidth
                height: 5
            }

            ZeUi.ZTextField {
                label: "Name"
                labelWidth: 30
                borderWidth: 1
                width: objAddDialog.dialogWidth
                onFieldTextChanged: {
                    objAddDialog.nameField = fieldText;
                }
                Component.onCompleted: {
                    if(objAddDialog.isUpdate){
                        fieldText = objAddDialog.nameField;
                    }
                }
            }

            ZeUi.ZSpacer{
                width:objAddDialog.dialogWidth
                height: 5
            }

            ZeUi.ZTextField {
                label: "Group"
                labelWidth: 30
                borderWidth: 1
                width: objAddDialog.dialogWidth
                onFieldTextChanged: {
                    objAddDialog.groupField = fieldText;
                }
                Component.onCompleted: {
                    if(objAddDialog.isUpdate){
                        fieldText = objAddDialog.groupField;
                    }
                    else{
                        fieldText = objAddDialog.groupField;
                    }
                }
            }

            ZeUi.ZSpacer{
                width:objAddDialog.dialogWidth
                height: 5
            }

            ZeUi.ZTextField {
                label: "Tags"
                labelWidth: 30
                borderWidth: 1
                width: objAddDialog.dialogWidth
                onFieldTextChanged: {
                    objAddDialog.tagsField = fieldText;
                }
                Component.onCompleted: {
                    if(objAddDialog.isUpdate){
                        fieldText = objAddDialog.tagsField;
                    }
                }
            }

        }
    }
}
