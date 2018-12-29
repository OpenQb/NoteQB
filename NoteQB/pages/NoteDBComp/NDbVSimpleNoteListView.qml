import Qb.ORM 1.0
import QtQuick 2.0

Rectangle {

    QbORMQueryModel{
        id: objNoteQueryModel
        query: objNoteManager.noteQuery
    }

    ListView{
        id: objNoteListView
        model: objNoteQueryModel
        anchors.fill: parent

        delegate: Rectangle{
            width: objNoteListView.width
            height: 100
            Text{
                anchors.fill: parent
                anchors.centerIn: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Name: "+name+" Group:"+group
            }
        }
    }
}
