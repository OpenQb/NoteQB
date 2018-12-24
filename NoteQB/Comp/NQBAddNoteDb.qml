import QtQuick 2.10
import QtQml.Models 2.10

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
        NQBTextField {
            id: objNameField
            label: "Name"
            labelWidth: 30
            borderWidth: 1
            width: objAddNoteDbDialog.dialogWidth
            useAlternateColor: false
        }
    }
}
