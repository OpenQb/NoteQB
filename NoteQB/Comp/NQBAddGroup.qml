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
    id: objAddGroupDialog
    title: "Add Group"
    enableStatusBar: true
    statusBarButtonText: "ADD"
    topRadius: 0

    property string group;


    function resetFields(){
        group = "";
    }

    function getDataMap(){
        var m = {};
        m["group"] = group;
        return m;
    }

    modelComponent: Component{
        ObjectModel{
            ZeUi.ZSpacer{
                width:objAddGroupDialog.dialogWidth
                height: 5
            }

            ZeUi.ZTextField {
                id: objGroupField
                label: "Group Name"
                labelWidth: 30
                borderWidth: 1
                width: objAddGroupDialog.dialogWidth
                onFieldTextChanged: {
                    objAddGroupDialog.group = fieldText;
                }
            }
        }
    }
}
