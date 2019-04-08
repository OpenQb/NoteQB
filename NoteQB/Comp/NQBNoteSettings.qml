import Qb 1.0
import Qb.Core 1.0

import QtQuick 2.10
import QtQml.Models 2.10
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

import "./../Core" as Core
import "./../Lang" as Lang
import "./../../ZeUi" as ZeUi


ZeUi.ZDialogPopupUi{
    id: objDialog
    title: "Note Settings"
    enableStatusBar: true
    statusBarButtonText: "SAVE"

    property string fontFamily: "Ubuntu";
    property int fontPixelSize: 15;
    property bool showLineNumbers: true;
    property bool autoSave: false;


    modelComponent: Component{
        ObjectModel{

            ZeUi.ZSpacer{
                width:objDialog.dialogWidth
                height: 5
            }

            ZeUi.ZComboBox {
                label: "Font"
                labelWidth: 30
                borderWidth: 1
                width: objDialog.dialogWidth
                comboBoxModel: Qt.fontFamilies()
                comboBox.currentIndex: Qt.fontFamilies().indexOf(objDialog.fontFamily)

                borderColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.idarker(QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent,20)//QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                backgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").background

                labelFieldBackgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").background//useAlternateColor? QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.analagousColor(QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent)[0]:QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                labelFieldColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                labelFieldTextColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.textColor(labelFieldBackgroundColor)

                comboBoxBackgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.idarker(labelFieldBackgroundColor,20)
                textColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                comboBoxTextColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.textColor(comboBoxBackgroundColor)

                onFieldTextChanged: {
                    objDialog.fontFamily = fieldText;
                }
            }

            ZeUi.ZSpacer{
                width:objDialog.dialogWidth
                height: 5
            }

            ZeUi.ZSpinBox{
                label: "Font Size (px)"
                labelWidth: 30
                borderWidth: 1
                spinBoxTo: 50
                spinBoxFrom: 5
                spinBoxValue: objDialog.fontPixelSize
                width: objDialog.dialogWidth

                borderColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.idarker(QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent,20)//QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                backgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").background

                labelFieldBackgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").background//useAlternateColor? QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.analagousColor(QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent)[0]:QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                labelFieldColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                labelFieldTextColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.textColor(labelFieldBackgroundColor)

                textFieldBackgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.idarker(labelFieldBackgroundColor,20)
                textFieldColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                textFieldTextColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.textColor(textFieldBackgroundColor)
                onSpinBoxValueChanged:
                {
                    objDialog.fontPixelSize = spinBoxValue;
                }
            }

            ZeUi.ZSpacer{
                width:objDialog.dialogWidth
                height: 5
            }

            ZeUi.ZCheckBox{
                label: "Show line numbers"
                labelWidth: 50
                borderWidth: 1
                width: objDialog.dialogWidth
                checkBoxChecked: objDialog.showLineNumbers

                borderColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.idarker(QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent,20)//QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                backgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").background

                labelFieldBackgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").background//useAlternateColor? QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.analagousColor(QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent)[0]:QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                labelFieldColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                labelFieldTextColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.textColor(labelFieldBackgroundColor)

                textFieldBackgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.idarker(labelFieldBackgroundColor,20)
                textFieldColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                textFieldTextColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.textColor(textFieldBackgroundColor)
                onCheckBoxCheckedChanged:
                {
                    objDialog.showLineNumbers = checkBoxChecked;
                }
            }

            ZeUi.ZSpacer{
                width:objDialog.dialogWidth
                height: 5
            }

            ZeUi.ZCheckBox{
                label: "Auto Save"
                labelWidth: 30
                borderWidth: 1
                width: objDialog.dialogWidth
                checkBoxChecked: objDialog.autoSave

                borderColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.idarker(QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent,20)//QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                backgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").background

                labelFieldBackgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").background//useAlternateColor? QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.analagousColor(QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent)[0]:QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                labelFieldColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                labelFieldTextColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.textColor(labelFieldBackgroundColor)

                textFieldBackgroundColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.idarker(labelFieldBackgroundColor,20)
                textFieldColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").accent
                textFieldTextColor: QbUtil.getAppObject(objDialog.appId,"ZBTheme").metaTheme.textColor(textFieldBackgroundColor)
                onCheckBoxCheckedChanged:
                {
                    objDialog.autoSave = checkBoxChecked;
                }
            }

        }
    }
}
