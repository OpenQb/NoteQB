import Qb 1.0
import Qb.Core 1.0
import QtQuick 2.10

import "ZeUi" as ZeUi
import "./NoteQB/Core" as Core

ZeUi.ZSOneAppUi{
    id: objMainAppUi
    dockLogo: objMainAppUi.absoluteURL("/NoteQB/images/NoteQB.png")
    changeWindowPosition: true
    onLogoClicked: {
        objMainAppUi.changePage(0);
    }

    QbSettings{
        id: objMainSettings
        name: "NoteQB"
        property alias windowWidth: objMainAppUi.windowWidth
        property alias windowHeight: objMainAppUi.windowHeight
        property alias windowX: objMainAppUi.windowX
        property alias windowY: objMainAppUi.windowY
    }

    Component.onCompleted: {
        var theme = {};
        theme["primary"] = "#004361";
        theme["secondary"] = "#007290";
        theme["background"] = "white";
        theme["accent"] = "#A3D5EF";
        theme["theme"] = "light";
        theme["error"] = "#B00020";
        theme["foreground"] = "black";
        ZeUi.ZBTheme.metaTheme.setThemeFromJsonData(JSON.stringify(theme));

        if(parseInt(QbApplicationBuildNumber)<1900)
        {
            objMainAppUi.addPage("/NoteQB/pages/Error.qml",{});
        }
        else
        {
            Core.NQBOne.addPage("##NoteQB##","/NoteQB/pages/NoteQB.qml");
        }
    }
}
