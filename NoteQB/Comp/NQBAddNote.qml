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
    title: "Add Note"
    enableStatusBar: true
    statusBarButtonText: "ADD"
    topRadius: 0

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
        m["name"] = nameField;
        m["group"] = groupField;
        m["tags"] = QbUtil.stringTokenList(tagsField,',');
        m["status"] = 0;
        m["reminder"] = 0;
        return m;
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
            }

        }
    }
}
