/*
 * Copyright (C) 2020 by Savoir-faire Linux
 * Author: Sébastien blin <sebastien.blin@savoirfairelinux.com>
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

import net.jami.Constants 1.1

// TODO: this component suffers from excessive responsibility
// and should have fixed width and content width defined variations
// as well as better handling for the animated icon
AbstractButton {
    id: root

    property bool outlined: false
    property real cornerRadius: JamiTheme.primaryRadius
    property alias toolTipText: toolTip.text
    property alias iconSource: icon.source_
    property alias animatedIconSource: icon.animatedSource_
    property real iconSize: 18
    property var color: JamiTheme.buttonTintedBlue
    property var hoveredColor: JamiTheme.buttonTintedBlueHovered
    property var pressedColor: JamiTheme.buttonTintedBluePressed
    property var keysNavigationFocusColor: Qt.darker(hoveredColor, 2)
    property bool hasIcon: animatedIconSource.length !== 0 ||
                           iconSource.length !== 0

    property var preferredWidth
    Binding on width {
        when: root.preferredWidth !== undefined ||
              root.Layout.fillWidth
        value: root.preferredWidth
    }
    Binding on Layout.preferredWidth {
        when: root.preferredWidth !== undefined ||
              root.Layout.fillWidth
        value: width
    }

    property real preferredHeight: 36
    height: preferredHeight
    Layout.preferredHeight: height

    focusPolicy: Qt.TabFocus
    hoverEnabled: true
    scale: !enabled ? 1 : ((down || enterKey.pressed) ? 0.975 : 1)
    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

    Accessible.role: Accessible.Button
    Accessible.name: root.text.length ? root.text : toolTipText
    Accessible.description: toolTipText

    MaterialToolTip {
        id: toolTip

        parent: root
        visible: root.enabled && root.hovered && (toolTipText.length > 0)
        delay: Qt.styleHints.mousePressAndHoldInterval
    }

    property string contentColorProvider: {
        if (!root.outlined)
            return "white"
        if (!root.enabled)
            return root.color
        if (root.down || enterKey.pressed)
            return root.pressedColor
        if (root.hovered)
            return root.hoveredColor
        return root.color
    }

    contentItem: Item {
        id: item
        opacity: root.enabled ? 1 : 0.45

        Binding on implicitWidth {
            when: root.preferredWidth === undefined ||
                  !root.Layout.fillWidth
            value: item.childrenRect.width
        }
        implicitHeight: childrenRect.height
        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            Binding on width {
                when: root.preferredWidth !== undefined ||
                      root.Layout.fillWidth
                value: root.availableWidth
            }
            spacing: hasIcon ?
                         JamiTheme.preferredMarginSize :
                         0

            Component {
                id: iconComponent

                ResponsiveImage {
                    source: source_
                    Layout.preferredWidth: iconSize
                    Layout.preferredHeight: iconSize
                    color: contentColorProvider
                }
            }

            Component {
                id: animatedIconComponent

                AnimatedImage {
                    source: animatedSource_
                    Layout.preferredWidth: iconSize
                    Layout.preferredHeight: iconSize
                    width: iconSize
                    height: iconSize
                    playing: true
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                }
            }

            Loader {
                id: icon

                property string source_
                property string animatedSource_

                active: hasIcon

                Layout.preferredWidth: active * width

                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: hasIcon ?
                                       JamiTheme.preferredMarginSize :
                                       undefined
                sourceComponent: animatedSource_.length !== 0 ?
                                     animatedIconComponent :
                                     iconComponent
            }

            Text {
                // this right margin will make the text visually
                // centered within button
                Layout.rightMargin: {
                    if ((!hasIcon || root.preferredWidth === undefined) &&
                            !root.Layout.fillWidth)
                        return undefined
                    return icon.width + JamiTheme.preferredMarginSize / 2 +
                            parent.spacing
                }
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: root.text
                font: root.font
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: contentColorProvider
            }
        }
    }

    background: Rectangle {
        opacity: root.enabled ? 1 : 0.45
        Behavior on color { ColorAnimation { duration: 140 } }
        color: {
            if (root.outlined)
                return "transparent"
            if (!root.enabled)
                return root.color
            if (root.down || enterKey.pressed)
                return root.pressedColor
            if (root.hovered)
                return root.hoveredColor
            return root.color
        }
        border.width: root.enabled && root.visualFocus ? 2 : 1
        border.color: {
            if (root.enabled && root.visualFocus)
                return root.outlined ? root.keysNavigationFocusColor : "#e4f4f8"
            if (!root.outlined)
                return "transparent"
            if (!root.enabled)
                return root.color
            if (root.down || enterKey.pressed)
                return root.pressedColor
            if (root.hovered)
                return root.hoveredColor
            return root.color
        }
        radius: root.cornerRadius
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: Math.max(0, parent.radius - 1)
            visible: !root.outlined && root.cornerRadius >= 20
            color: "transparent"
            border.width: 1
            border.color: root.down || enterKey.pressed ? "#10314d63" : "#4065edff"
        }
    }

    QtObject {
        id: enterKey
        property bool pressed: false
    }

    onActiveFocusChanged: if (!activeFocus) enterKey.pressed = false
    onEnabledChanged: if (!enabled) enterKey.pressed = false

    Keys.onPressed: function (keyEvent) {
        if (keyEvent.key === Qt.Key_Enter ||
                keyEvent.key === Qt.Key_Return) {
            keyEvent.accepted = true
            if (root.enabled && root.activeFocus && !keyEvent.isAutoRepeat)
                enterKey.pressed = true
        }
    }

    Keys.onReleased: function (keyEvent) {
        if (keyEvent.key === Qt.Key_Enter || keyEvent.key === Qt.Key_Return) {
            keyEvent.accepted = true
            if (keyEvent.isAutoRepeat)
                return
            var activate = enterKey.pressed && root.enabled && root.activeFocus
            enterKey.pressed = false
            if (!activate)
                return
            // Action.trigger() forwards clicked itself; do not emit it twice.
            if (root.action) {
                root.action.trigger(root)
            } else {
                if (root.checkable && !(root.autoExclusive && root.checked)) {
                    root.toggle()
                    root.toggled()
                }
                root.clicked()
            }
        }
    }
}
