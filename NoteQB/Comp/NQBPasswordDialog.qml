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
    id: objDialog
    title: "Enter password"
    enableStatusBar: true
    statusBarButtonText: "OPEN"
    topRadius: 0

    property string passwordField: "";
    property string pathField: "";

    function resetFields()
    {
        passwordField = "";
        pathField = "";
    }

    function isValid()
    {
        return passwordField !== "" && pathField !== "";
    }


    modelComponent: Component{
        ObjectModel{

            ZeUi.ZSpacer{
                width:objDialog.dialogWidth
                height: 5
            }

            ZeUi.ZTextField {
                label: "Password"
                labelWidth: 30
                borderWidth: 1
                width: objDialog.dialogWidth
                textInputItem.inputMethodHints: Qt.ImhHiddenText|Qt.ImhSensitiveData
                textInputItem.echoMode: TextInput.Password
                onFieldTextChanged: {
                    objDialog.passwordField = fieldText;
                }
            }
        }
    }
}
