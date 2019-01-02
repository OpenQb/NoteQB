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
    title: "Error"
    enableStatusBar: true
    statusBarButtonText: "CLOSE"
    topRadius: 0

    property string errorField: "";

    function resetFields()
    {
        errorField = "";
    }
    onButtonClicked: {
        objDialog.close();
    }

    modelComponent: Component{
        ObjectModel{
            Text{
                width: objDialog.dialogWidth
                height: objDialog.dialogHeight*0.50
                text: objDialog.errorField
                font.pixelSize: 20
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
