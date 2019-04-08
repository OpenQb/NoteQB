/*

  Code From: https://github.com/olegyadrov/qmlcreator/blob/master/qml/components/CCodeArea.qml
*/

import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Qb.QbSyntax 1.0

Item {
    id: objTextViewer

    property alias text: textEdit.text
    property alias selectedText: textEdit.selectedText
    property alias textEditItem: textEdit
    property alias scrollBarItem: objScrollBar
    property alias readOnly: textEdit.readOnly

    property int indentSize: 0
    property int pixelDensity: 1

    property color lineNumberColor: "grey"
    property color currentLineNumberColor: "black"
    property color lineNumberBackgroundColor: "lightgrey"

    property color editorSelectionHandle: "green"
    property color cursorColor: "black"

    property string fontFamily: "Ubuntu"
    property int fontSize: 14
    property bool showLineNumbers: true;

    onIndentSizeChanged: {
        var indentString = ""
        for (var i = 0; i < indentSize; i++)
            indentString += " "
        textEdit.indentString = indentString
    }

    function paste() {
        textEdit.textChangedManually = true;
        textEdit.paste();
    }

    function copy() {
        textEdit.copy();
    }

    function cut() {
        textEdit.textChangedManually = true;
        textEdit.cut();
    }

    function selectAll() {
        textEdit.selectAll();
        textEdit.leftSelectionHandle.setPosition();
        textEdit.rightSelectionHandle.setPosition();
    }

    onActiveFocusChanged: {
        if (activeFocus)
            textEdit.forceActiveFocus()
    }

    Rectangle {
        id: lineNumbers
        anchors.top: parent.top
        anchors.left: parent.left

        height: parent.height
        width: visible?objTextDocHelper.lineNumberAreaWidth+5:0
        color: objTextViewer.lineNumberBackgroundColor
        visible: objTextViewer.showLineNumbers

        Column {
            id: column
            y: 3 * objTextViewer.pixelDensity - flickable.contentY
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: objTextDocHelper.totalLineNumber
                delegate: Rectangle{
                    height: objTextDocHelper.lineData(index).height
                    width: lineNumbers.width
                    color: objTextViewer.lineNumberBackgroundColor//index%2?"green":"yellow"
                    Text {
                        width: parent.width - 5
                        height: parent.height
                        id: objLineNo
                        color: index + 1 === objTextDocHelper.currentLineNumber ? objTextViewer.currentLineNumberColor : objTextViewer.lineNumberColor
                        font.family: objTextDocHelper.lineNumberFont.family
                        font.pixelSize: objTextDocHelper.lineNumberFont.pixelSize
                        font.bold: index + 1 === objTextDocHelper.currentLineNumber
                        text: index + 1
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }
    }

    Flickable {
        id: flickable
        x: lineNumbers.width
        y: 0
        height: parent.height
        width: parent.width - lineNumbers.width

        interactive: true
        clip: true

        ScrollBar.vertical: ScrollBar {
            id: objScrollBar
//            contentItem: Rectangle {
//                implicitWidth: 6
//                implicitHeight: 100
//                radius: width / 2
//                color: objScrollBar.pressed ? "#81e889" : "#c2f4c6"
//            }
        }

        ScrollBar.horizontal: ScrollBar{
            id: objHScrollBar
//            contentItem: Rectangle {
//                implicitWidth: 100
//                implicitHeight: 6
//                radius: height / 2
//                color: objHScrollBar.pressed ? "#81e889" : "#c2f4c6"
//            }
        }

        function ensureVisible(cursor)
        {

            if (contentY >= cursor.y)
                contentY = cursor.y
            else if (contentY + height <= cursor.y + cursor.height)
                contentY = cursor.y + cursor.height - height

            if (contentX >= cursor.x)
                contentX = cursor.x
            else if (contentX + width <= cursor.x + cursor.width)
                contentX = cursor.x + cursor.width - width

            //            if (textEdit.currentLine === 1)
            //            {
            //                contentY = 0;
            //                contentX = contentWidth - width;
            //            }
            //            else if (textEdit.currentLine === textEdit.lineCount && flickable.visibleArea.heightRatio < 1)
            //            {
            //                contentY = contentHeight - height
            //                contentX = contentWidth - width;
            //            }
            //            else
            //            {
            //                if (contentY >= cursor.y)
            //                    contentY = cursor.y
            //                else if (contentY + height <= cursor.y + cursor.height)
            //                    contentY = cursor.y + cursor.height - height

            //                if (contentX >= cursor.x)
            //                    contentX = cursor.x
            //                else if (contentX + width <= cursor.x + cursor.width)
            //                    contentX = cursor.x + cursor.width - width
            //            }

        }

        TextEdit {
            id: textEdit

            //color: "black"
            //selectionColor: palette.editorSelection
            //selectedTextColor: palette.editorSelectedText

            font.family: objTextViewer.fontFamily
            font.pixelSize: objTextViewer.fontSize
            textMargin: 5 * objTextViewer.pixelDensity
            wrapMode: TextEdit.NoWrap
            textFormat: TextEdit.PlainText
            inputMethodHints: Qt.ImhNoPredictiveText
            activeFocusOnPress: false
            onCursorRectangleChanged: {
                flickable.ensureVisible(cursorRectangle);
                objTextDocHelper.cursorPos = textEdit.cursorPosition;
                objTextDocHelper.cursorRectangle = cursorRectangle;
            }
            cursorDelegate: Component{
                Rectangle{
                    color: "black"
                    width: 2
                    visible: !textEdit.readOnly
                }
            }

            property string indentString: ""

            property int currentLine: cursorRectangle.y / cursorRectangle.height + 1

            onContentHeightChanged:
                flickable.contentHeight = contentHeight
            onContentWidthChanged:
                flickable.contentWidth = contentWidth

            property bool textChangedManually: false
            property string previousText: ""

            QbTextDocumentHelper{
                id: objTextDocHelper
                textArea: textEdit
                lineNumberFont: textEdit.font
                onLineNumberFontChanged: {
                    objTextDocHelper.refresh();
                }
            }


            //            onLengthChanged: {
            //                if (objTextViewer.indentSize === 0)
            //                    return

            //                // This is kind of stupid workaround, we forced to do this check because TextEdit sends
            //                // us "textChanged" and "lengthChanged" signals after every select() and forceActiveFocus() call
            //                if (text !== previousText)
            //                {
            //                    if (textChangedManually)
            //                    {
            //                        previousText = text
            //                        textChangedManually = false
            //                        return
            //                    }

            //                    if (length > previousText.length)
            //                    {
            //                        var textBeforeCursor
            //                        var openBrackets
            //                        var closeBrackets
            //                        var openBracketsCount
            //                        var closeBracketsCount
            //                        var indentDepth
            //                        var indentString

            //                        var lastCharacter = text[cursorPosition - 1]

            //                        switch (lastCharacter)
            //                        {
            //                        case "\n":
            //                            textBeforeCursor = text.substring(0, cursorPosition - 1)
            //                            openBrackets = textBeforeCursor.match(/\{/g)
            //                            closeBrackets = textBeforeCursor.match(/\}/g)

            //                            if (openBrackets !== null)
            //                            {
            //                                openBracketsCount = openBrackets.length
            //                                closeBracketsCount = 0

            //                                if (closeBrackets !== null)
            //                                    closeBracketsCount = closeBrackets.length

            //                                indentDepth = openBracketsCount - closeBracketsCount
            //                                indentString = new Array(indentDepth + 1).join(textEdit.indentString)
            //                                textChangedManually = true
            //                                insert(cursorPosition, indentString)
            //                            }
            //                            break
            //                        case "}":
            //                            var lineBreakPosition
            //                            for (var i = cursorPosition - 2; i >= 0; i--)
            //                            {
            //                                if (text[i] !== " ")
            //                                {
            //                                    if (text[i] === "\n")
            //                                        lineBreakPosition = i

            //                                    break
            //                                }
            //                            }

            //                            if (lineBreakPosition !== undefined)
            //                            {
            //                                textChangedManually = true
            //                                remove(lineBreakPosition + 1, cursorPosition - 1)

            //                                textBeforeCursor = text.substring(0, cursorPosition - 1)
            //                                openBrackets = textBeforeCursor.match(/\{/g)
            //                                closeBrackets = textBeforeCursor.match(/\}/g)

            //                                if (openBrackets !== null)
            //                                {
            //                                    openBracketsCount = openBrackets.length
            //                                    closeBracketsCount = 0

            //                                    if (closeBrackets !== null)
            //                                        closeBracketsCount = closeBrackets.length

            //                                    indentDepth = openBracketsCount - closeBracketsCount - 1
            //                                    indentString = new Array(indentDepth + 1).join(textEdit.indentString)
            //                                    textChangedManually = true
            //                                    insert(cursorPosition - 1, indentString)
            //                                }
            //                            }

            //                            break
            //                        }
            //                    }

            //                    previousText = text
            //                }
            //            }


            Component.onCompleted: {
            }

            property Item leftSelectionHandle: Item {
                width: textEdit.cursorRectangle.height
                height: width
                parent: textEdit
                visible: textEdit.selectedText !== ""
                onXChanged:
                    if (leftSelectionMouseArea.pressed)
                        select()
                onYChanged:
                    if (leftSelectionMouseArea.pressed)
                        select()

                function select() {
                    var currentPosition = textEdit.positionAt(x + width / 2, y + height)
                    if (currentPosition < textEdit.selectionEnd)
                    {
                        textEdit.select(currentPosition, textEdit.selectionEnd)
                        flickable.ensureVisible(textEdit.positionToRectangle(textEdit.selectionStart))
                    }
                }

                function setPosition() {
                    var positionRectangle = textEdit.positionToRectangle(textEdit.selectionStart)
                    textEdit.leftSelectionHandle.x = positionRectangle.x - textEdit.leftSelectionHandle.width / 2
                    textEdit.leftSelectionHandle.y = positionRectangle.y - textEdit.leftSelectionHandle.height
                }

                MouseArea {
                    id: leftSelectionMouseArea
                    anchors.fill: parent
                    anchors.margins: -parent.width / 1.5
                    drag.target: textEdit.leftSelectionHandle
                    drag.smoothed: false
                    onReleased:
                        textEdit.leftSelectionHandle.setPosition()
                }

                Connections {
                    target: (leftSelectionMouseArea.pressed) ? null : textEdit
                    onCursorPositionChanged:
                        textEdit.leftSelectionHandle.setPosition()
                }

                Rectangle {
                    anchors.horizontalCenter: parent.left
                    width: parent.width
                    height: parent.height
                    radius: width / 2
                    color: objTextViewer.editorSelectionHandle

                    Rectangle {
                        width: Math.floor(parent.width / 2)
                        height: width
                        color: parent.color
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                    }
                }
            }

            property Item rightSelectionHandle: Item {
                width: textEdit.cursorRectangle.height
                height: width
                parent: textEdit
                visible: textEdit.selectedText !== ""
                onXChanged:
                    if (rightSelectionMouseArea.pressed)
                        select()
                onYChanged:
                    if (rightSelectionMouseArea.pressed)
                        select()

                function select() {
                    var currentPosition = textEdit.positionAt(x + width / 2, y)
                    if (currentPosition > textEdit.selectionStart)
                    {
                        textEdit.select(textEdit.selectionStart, currentPosition)
                        flickable.ensureVisible(textEdit.positionToRectangle(textEdit.selectionEnd))
                    }
                }

                function setPosition() {
                    var positionRectangle = textEdit.positionToRectangle(textEdit.selectionEnd)
                    textEdit.rightSelectionHandle.x = positionRectangle.x - textEdit.rightSelectionHandle.width / 2
                    textEdit.rightSelectionHandle.y = positionRectangle.y + positionRectangle.height
                }

                MouseArea {
                    id: rightSelectionMouseArea
                    anchors.fill: parent
                    anchors.margins: -parent.width / 1.5
                    drag.target: textEdit.rightSelectionHandle
                    drag.smoothed: false
                    onReleased:
                        textEdit.rightSelectionHandle.setPosition()
                }

                Connections {
                    target: (rightSelectionMouseArea.pressed) ? null : textEdit
                    onCursorPositionChanged:
                        textEdit.rightSelectionHandle.setPosition()
                }

                Rectangle {
                    anchors.horizontalCenter: parent.right
                    width: parent.width
                    height: parent.height
                    radius: width / 2
                    color: objTextViewer.editorSelectionHandle

                    Rectangle {
                        width: Math.floor(parent.width / 2)
                        height: width
                        color: parent.color
                        anchors.top: parent.top
                        anchors.left: parent.left
                    }
                }
            }

            onCursorPositionChanged:
                textEdit.contextMenu.visible = false

            property Item contextMenu: ListView {
                parent: textEdit
                visible: false

                property int margin: 3
                property int delegateWidth: 60 * objTextViewer.pixelDensity
                property int delegateHeight: 40 * objTextViewer.pixelDensity

                width: delegateWidth
                height: delegateHeight * count
                boundsBehavior: Flickable.StopAtBounds

                model: ListModel {
                    ListElement { text: qsTr("Undo") }
                    ListElement { text: qsTr("Redo") }
                    ListElement { text: qsTr("Paste") }
                }

                function contextMenuCallback(index) {
                    visible = false
                    switch (index)
                    {
                    case 0:
                        textEdit.undo()
                        break
                    case 1:
                        textEdit.redo()
                        break
                    case 2:
                        objTextViewer.paste()
                        break
                    }
                }

                delegate: Button {
                    Material.background: Material.Teal
                    Material.theme: Material.Light
                    width: ListView.view.delegateWidth
                    height: ListView.view.delegateHeight
                    text: model.text
                    onClicked: ListView.view.contextMenuCallback(index)
                }

                onVisibleChanged: {
                    if (visible)
                    {
                        var positionRectangle = textEdit.positionToRectangle(textEdit.cursorPosition)

                        if (isEnoughSpaceAtLeft() && !isEnoughSpaceAtRight())
                            x = textEdit.width - width - margin
                        else if (!isEnoughSpaceAtLeft() && isEnoughSpaceAtRight())
                            x = margin
                        else
                            x = positionRectangle.x - width / 2

                        if (isEnoughSpaceAtTop())
                            y = positionRectangle.y - margin - height
                        else if (isEnoughSpaceAtBottom())
                            y = positionRectangle.y + positionRectangle.height + margin
                        else
                            y = positionRectangle.y + positionRectangle.height / 2 - height / 2
                    }
                }

                function isEnoughSpaceAtTop() {
                    var positionRectangle = textEdit.positionToRectangle(textEdit.cursorPosition)
                    return (positionRectangle.y  - height - margin > flickable.contentY)
                }

                function isEnoughSpaceAtBottom() {
                    var positionRectangle = textEdit.positionToRectangle(textEdit.cursorPosition)
                    return (positionRectangle.y  + positionRectangle.height + height + margin < flickable.contentY + flickable.height)
                }

                function isEnoughSpaceAtLeft() {
                    var positionRectangle = textEdit.positionToRectangle(textEdit.cursorPosition)
                    return (positionRectangle.x - width / 2 > 0)
                }

                function isEnoughSpaceAtRight() {
                    var positionRectangle = textEdit.positionToRectangle(textEdit.cursorPosition)
                    return (positionRectangle.x + width / 2 < textEdit.width)
                }
            }


            MouseArea {
                anchors.fill: parent

                preventStealing: true

                property int startX
                property int startY
                property int startPosition
                property int endPosition

                onPressed: {
                    //console.log("Pressed");
                    textEdit.contextMenu.visible = false;

                    startX = mouse.x;
                    startY = mouse.y;
                    startPosition = textEdit.positionAt(mouse.x, mouse.y);
                    textEdit.cursorPosition = startPosition;
                    objTextDocHelper.cursorPos = textEdit.cursorPosition;
                    textEdit.forceActiveFocus();

                    if (!Qt.inputMethod.visible)
                        Qt.inputMethod.show();

                    mouse.accepted = true;
                }

                onPositionChanged: {
                    if (textEdit.contextMenu.visible)
                    {
                        mouse.accepted = true
                        return
                    }

                    var newPosition = textEdit.positionAt(mouse.x, mouse.y)
                    if (newPosition !== endPosition)
                    {
                        endPosition = newPosition
                        textEdit.select(startPosition, endPosition)
                        if (newPosition > startPosition)
                            flickable.ensureVisible(textEdit.positionToRectangle(textEdit.selectionEnd))
                        else
                            flickable.ensureVisible(textEdit.positionToRectangle(textEdit.selectionStart))
                    }
                    mouse.accepted = true
                }

                onPressAndHold: {
                    var distance = Math.sqrt(Math.pow(mouse.x - startX, 2) + Math.pow(mouse.y - startY, 2))
                    if (distance < textEdit.cursorRectangle.height)
                    {
                        if (textEdit.selectedText.length === 0)
                            textEdit.contextMenu.visible = true
                    }
                    mouse.accepted = true
                }
            }//MouseArea
        }//TextEdit

    }//Flickable


    MouseArea {
        anchors.fill: parent
        onPressed: {
            if(textEdit.length === 0) textEdit.cursorPosition = 0;
            textEdit.forceActiveFocus();
            if (!Qt.inputMethod.visible)
                Qt.inputMethod.show();
            mouse.accepted = false;
        }
    }
}
