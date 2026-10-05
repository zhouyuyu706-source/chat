/*
 * Copyright (C) 2020 by Savoir-faire Linux
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

Rectangle {
    id: root
    anchors.fill: parent
    color: JamiTheme.secondaryBackgroundColor
    Atmosphere { anchors.fill: parent }
    property bool copied: false
    readonly property string bestId: UtilsAdapter.getBestId(LRCInstance.currentAccountId)
    onBestIdChanged: { copied = false; copyTimer.stop() }
    Timer { id: copyTimer; interval: 1800; onTriggered: root.copied = false }

    Flickable {
        id: viewport
        anchors.fill: parent
        anchors.topMargin: 36
        clip: true
        contentWidth: width
        contentHeight: Math.max(viewport.height, homeContent.height + 64)
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
        ColumnLayout {
            id: homeContent
            height: implicitHeight
            width: Math.max(240, Math.min(480, viewport.width - 48))
            x: (viewport.width - width) / 2
            y: Math.max(32, (viewport.height - implicitHeight) / 2)
            spacing: 0
            BrandLogo {
                Layout.preferredWidth: 176
                Layout.preferredHeight: 60
                Layout.bottomMargin: 26
                source: JamiTheme.darkTheme ? JamiResources.logo_jami_standard_coul_white_svg : JamiResources.logo_jami_standard_coul_svg
            }
            Text {
                text: "开始聊天"
                color: JamiTheme.textColor
                font.pixelSize: 26
                font.weight: Font.DemiBold
                Layout.bottomMargin: 10
            }
            Text {
                Layout.fillWidth: true
                text: "在左侧搜索联系人，或把你的识别码发给对方。"
                color: JamiTheme.darkTheme ? "#a0adbd" : "#536777"
                font.pixelSize: 13
                wrapMode: Text.WordWrap
                lineHeight: 1.4
                Layout.bottomMargin: 28
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 132
                Layout.bottomMargin: 20
                visible: LRCInstance.currentAccountType === Profile.Type.JAMI
                color: JamiTheme.darkTheme ? "#151f2b" : "#f4f8fc"
                border.color: JamiTheme.darkTheme ? "#304052" : "#cbd9e6"
                radius: 14
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10
                    Text { text: "我的识别码"; font.pixelSize: 12; color: JamiTheme.darkTheme ? "#a0adbd" : "#536777" }
                    TextEdit {
                        id: identityText
                        objectName: "homeIdentity"
                        Layout.fillWidth: true
                        text: root.bestId
                        readOnly: true
                        selectByMouse: true
                        wrapMode: TextEdit.WrapAnywhere
                        color: JamiTheme.textColor
                        selectionColor: "#315d82"
                        selectedTextColor: "#f4f8fc"
                        font.family: "Consolas"
                        font.pixelSize: 13
                        Accessible.name: "我的识别码"
                    }
                    RowLayout {
                        spacing: 8
                        Button {
                            id: copyButton
                            objectName: "copyRegisterednameButton"
                            text: root.copied ? "已复制" : "复制识别码"
                            enabled: root.bestId.length > 0
                            Accessible.name: text
                            focusPolicy: Qt.StrongFocus
                            implicitHeight: 32
                            implicitWidth: 104
                            contentItem: Text { text: copyButton.text; color: JamiTheme.darkTheme ? "#c6ddf0" : "#24577c"; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                            background: Rectangle {
                                radius: 7
                                color: copyButton.down ? (JamiTheme.darkTheme ? "#324b64" : "#ccdfed") : (JamiTheme.darkTheme ? "#25384c" : "#e0edf7")
                                border.color: copyButton.visualFocus ? "#85b9e0" : "transparent"
                            }
                            onClicked: { UtilsAdapter.setClipboardText(root.bestId); root.copied = true; copyTimer.restart() }
                        }
                        Button {
                            id: inviteButton
                            objectName: "homeInvite"
                            text: "我的二维码"
                            flat: true
                            enabled: root.bestId.length > 0
                            Accessible.name: text
                            focusPolicy: Qt.StrongFocus
                            implicitHeight: 32
                            contentItem: Text { text: inviteButton.text; color: JamiTheme.darkTheme ? "#b6cce0" : "#345f7e"; font.pixelSize: 12; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                            background: Rectangle {
                                radius: 7
                                color: inviteButton.down || inviteButton.hovered ? (JamiTheme.darkTheme ? "#243447" : "#e0edf7") : "transparent"
                                border.color: inviteButton.visualFocus ? "#85b9e0" : "transparent"
                            }
                            onClicked: qrDialog.open()
                        }
                    }
                }
            }
            QuickAction {
                objectName: "homeAddContact"
                Layout.fillWidth: true
                heading: "添加联系人"
                detail: "输入用户名或粘贴对方的识别码"
                iconSource: JamiResources.chat_black_24dp_svg
                onClicked: mainViewSidePanel.focusContactSearch()
            }
            Rectangle { Layout.fillWidth: true; Layout.leftMargin: 14; Layout.rightMargin: 14; Layout.preferredHeight: 1; color: JamiTheme.darkTheme ? "#263342" : "#d9e3ec" }
            QuickAction {
                objectName: "homeDevices"
                Layout.fillWidth: true
                heading: "账户与设备"
                detail: "查看当前账户，管理已关联的设备"
                iconSource: JamiResources.devices_24dp_svg
                onClicked: mainView.openAccountSettings()
            }
        }
    }
}
