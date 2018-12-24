import QtQuick 2.10
import QtQml.Models 2.10
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "./../../ZeUi" as ZeUi


ZeUi.ZDialogUi{
    id: objAddNoteDbDialog
    title: "Add Note Db"
    enableStatusBar: true
    statusBarButtonText: "ADD"
    topRadius: 0
    signal projectAdded();
    onButtonClicked: {

    }

    model: ObjectModel{

        ZeUi.ZTextField {
            id: objNameField
            label: "Name"
            labelWidth: 30
            borderWidth: 1
            width: objAddNoteDbDialog.dialogWidth
            useAlternateColor: false
        }

        ZeUi.ZSpacer{
            width:objAddNoteDbDialog.dialogWidth
            height: 5
        }

        ZeUi.ZFolderField{
            label: "Path"
            labelWidth: 30
            borderWidth: 1
            width: objAddNoteDbDialog.dialogWidth
            useAlternateColor: false
        }

        ZeUi.ZSpacer{
            width:objAddNoteDbDialog.dialogWidth
            height: 5
        }

    }
}
