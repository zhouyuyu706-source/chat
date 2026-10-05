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
import net.jami.Adapters 1.1
import net.jami.Constants 1.1
import "../../commoncomponents"

Popup {
    id: root
    parent: Overlay.overlay
    width: Math.min(360, parent.width - 32)
    height: contentColumn.implicitHeight + 40
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    modal: true
    focus: true
    padding: 20
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    property var returnFocusItem: null
    readonly property string qrSource: "image://qrImage/account_" + CurrentAccount.id
    onAboutToShow: returnFocusItem = appWindow.activeFocusItem
    onOpened: closeButton.forceActiveFocus()
    onClosed: {
        if (returnFocusItem && returnFocusItem.visible)
            returnFocusItem.forceActiveFocus()
    }
    Overlay.modal: Rectangle { color: "#99070d16" }
    background: Rectangle {
        radius: 16
        color: JamiTheme.darkTheme ? "#18222e" : "#f8fafc"
        border.color: JamiTheme.darkTheme ? "#435469" : "#c7d5e2"
    }
    contentItem: ColumnLayout {
        id: contentColumn
        spacing: 16
        RowLayout {
            Layout.fillWidth: true
            Text { Layout.fillWidth: true; text: "我的二维码"; color: JamiTheme.textColor; font.pixelSize: 18; font.weight: Font.DemiBold }
            PushButton {
                id: closeButton
                objectName: "closeInviteDialog"
                preferredSize: 32
                source: JamiResources.ic_clear_24dp_svg
                imageColor: JamiTheme.textColor
                normalColor: "transparent"
                toolTipText: "关闭"
                onClicked: root.close()
            }
        }
        Text { Layout.fillWidth: true; text: "让对方扫描二维码，添加你为联系人。"; wrapMode: Text.WordWrap; color: JamiTheme.darkTheme ? "#abb8c8" : "#52677c"; font.pixelSize: 12 }
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Math.min(256, root.availableWidth)
            Layout.preferredHeight: width
            color: "#ffffff"
            radius: 8
            Image {
                id: userQrImage
                objectName: "inviteQrImage"
                anchors.fill: parent
                anchors.margins: 12
                smooth: false
                cache: false
                fillMode: Image.PreserveAspectFit
                source: root.qrSource
                visible: status === Image.Ready
                Accessible.name: "添加联系人二维码"
            }
            Text {
                anchors.centerIn: parent
                visible: userQrImage.status !== Image.Ready
                text: userQrImage.status === Image.Error ? "二维码暂时无法显示" : "正在生成二维码"
                color: "#34465a"
                font.pixelSize: 12
            }
        }
        Button {
            Layout.alignment: Qt.AlignHCenter
            visible: userQrImage.status === Image.Error
            text: "重试"
            onClicked: { userQrImage.source = ""; userQrImage.source = Qt.binding(function() { return root.qrSource }) }
        }
    }
}
