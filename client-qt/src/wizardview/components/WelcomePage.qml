/*
 * Copyright (C) 2021 by Savoir-faire Linux
 * Author: Yang Wang <yang.wang@savoirfairelinux.com>
 * Author: Sébastien blin <sebastien.blin@savoirfairelinux.com>
 * Author: Mingrui Zhang <mingrui.zhang@savoirfairelinux.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import net.jami.Models 1.1
import net.jami.Adapters 1.1
import net.jami.Constants 1.1
import "../../commoncomponents"
import "../../mainview/components" as MainComponents

Rectangle {
    id: root
    color: JamiTheme.secondaryBackgroundColor
    property int preferredHeight: content.implicitHeight + 120
    property bool showImport: false
    property bool showAdvanced: false
    signal scrollToBottom
    signal showThisPage
    Connections {
        target: WizardViewStepModel
        function onMainStepChanged() {
            if (WizardViewStepModel.mainStep === WizardViewStepModel.MainSteps.Initial)
                root.showThisPage()
        }
    }
    onVisibleChanged: if (visible) forceActiveFocus()
    ColumnLayout {
        id: content
        anchors.centerIn: parent
        width: Math.min(500, root.width - 48)
        spacing: 12
        BrandLogo {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 260
            Layout.preferredHeight: 100
            Layout.bottomMargin: 22
            source: JamiResources.logo_jami_standard_coul_white_svg
        }
        Text {
            Layout.fillWidth: true
            text: "使用 Zova 自由、私密地分享"
            color: JamiTheme.textColor
            font.pointSize: 20
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
        Text {
            Layout.fillWidth: true
            Layout.topMargin: 18
            Layout.bottomMargin: 28
            text: "Zova 是一个以隐私为基础的通信平台，让你与亲友自由交流。"
            color: JamiTheme.textColor
            font.pointSize: 11
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
        MaterialButton {
            objectName: "newAccountButton"
            
            Layout.alignment: Qt.AlignHCenter
            preferredWidth: Math.min(400, content.width)
            preferredHeight: 48
            cornerRadius: 24
            text: "创建 Zova 账户"
            outlined: false
            onClicked: WizardViewStepModel.startAccountCreationFlow(WizardViewStepModel.AccountCreationOption.CreateJamiAccount)
        }

        MaterialButton {
            objectName: "existingAccountButton"
            
            Layout.alignment: Qt.AlignHCenter
            preferredWidth: Math.min(400, content.width)
            preferredHeight: 48
            cornerRadius: 24
            text: "我已经有一个账户"
            outlined: false
            onClicked: root.showImport = !root.showImport
        }

        MaterialButton {
            objectName: "fromDeviceButton"
            visible: root.showImport
            Layout.alignment: Qt.AlignHCenter
            preferredWidth: Math.min(400, content.width)
            preferredHeight: 48
            cornerRadius: 24
            text: JamiStrings.linkFromAnotherDevice
            outlined: true
            onClicked: WizardViewStepModel.startAccountCreationFlow(WizardViewStepModel.AccountCreationOption.ImportFromDevice)
        }

        MaterialButton {
            objectName: "fromBackupButton"
            visible: root.showImport
            Layout.alignment: Qt.AlignHCenter
            preferredWidth: Math.min(400, content.width)
            preferredHeight: 48
            cornerRadius: 24
            text: JamiStrings.connectFromBackup
            outlined: true
            onClicked: WizardViewStepModel.startAccountCreationFlow(WizardViewStepModel.AccountCreationOption.ImportFromBackup)
        }

        Button {
            objectName: "showAdvancedButton"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 8
            text: JamiStrings.advancedFeatures
            flat: true
            contentItem: Text { text: parent.text; color: JamiTheme.textColor; horizontalAlignment: Text.AlignHCenter }
            background: Item {}
            onClicked: root.showAdvanced = !root.showAdvanced
        }
        MaterialButton {
            objectName: "newRdvButton"
            visible: root.showAdvanced
            Layout.alignment: Qt.AlignHCenter
            preferredWidth: Math.min(400, content.width)
            preferredHeight: 48
            cornerRadius: 24
            text: JamiStrings.createRV
            outlined: true
            onClicked: WizardViewStepModel.startAccountCreationFlow(WizardViewStepModel.AccountCreationOption.CreateRendezVous)
        }

        MaterialButton {
            objectName: "connectAccountManagerButton"
            visible: root.showAdvanced
            Layout.alignment: Qt.AlignHCenter
            preferredWidth: Math.min(400, content.width)
            preferredHeight: 48
            cornerRadius: 24
            text: JamiStrings.connectJAMSServer
            outlined: true
            onClicked: WizardViewStepModel.startAccountCreationFlow(WizardViewStepModel.AccountCreationOption.ConnectToAccountManager)
        }

        MaterialButton {
            objectName: "newSIPAccountButton"
            visible: root.showAdvanced
            Layout.alignment: Qt.AlignHCenter
            preferredWidth: Math.min(400, content.width)
            preferredHeight: 48
            cornerRadius: 24
            text: JamiStrings.addSIPAccount
            outlined: true
            onClicked: WizardViewStepModel.startAccountCreationFlow(WizardViewStepModel.AccountCreationOption.CreateSipAccount)
        }

        onHeightChanged: root.scrollToBottom()
    }
    BackButton {
        objectName: "welcomePageBackButton"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: JamiTheme.wizardViewPageBackButtonMargins
        preferredSize: JamiTheme.wizardViewPageBackButtonSize
        visible: UtilsAdapter.getAccountListSize() > 0
        onClicked: WizardViewStepModel.previousStep()
    }
}
