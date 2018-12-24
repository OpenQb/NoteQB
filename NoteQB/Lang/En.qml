import QtQuick 2.0

QtObject {
    id: objLangEn


    property string sf1: qsTr("Name")
    property string sf2: qsTr("Path")
    property string sf3: qsTr("Db Format")

    property string se1: qsTr("Please provide a name");
    property string se2: qsTr("Please provide the path");
    property string se3: qsTr("Failed to add Note Db");
    property string se4: qsTr("File is not writable");
}
