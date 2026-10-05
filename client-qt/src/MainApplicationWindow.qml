/*
 * Copyright (C) 2020 by Savoir-faire Linux
 * Author: Aline Gondim Santos <aline.gondimsantos@savoirfairelinux.com>
 * Author: Andreas Traczyk <andreas.traczyk@savoirfairelinux.com>
 * Author: Albert Babí <albert.babi@savoirfairelinux.com>
 * Author: Mingrui Zhang <mingrui.zhang@savoirfairelinux.com>
 * Author: Yang Wang   <yang.wang@savoirfairelinux.com>
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
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import net.jami.Models 1.1
import net.jami.Adapters 1.1
import net.jami.Enums 1.1
import net.jami.Helpers 1.1
import net.jami.Constants 1.1

import "mainview"
import "wizardview"
import "commoncomponents"

ApplicationWindow {
    id: root

    enum LoadedSource {
        WizardView = 0,
        MainView,
        AccountMigrationView,
        None
    }

    property ApplicationWindow appWindow : root
    property bool isFullScreen: false

    function toggleFullScreen() {
        isFullScreen = !isFullScreen
    }

    function checkLoadedSource() {
        var sourceString = mainApplicationLoader.source.toString()

        if (sourceString === JamiQmlUtils.wizardViewLoadPath)
            return MainApplicationWindow.LoadedSource.WizardView
        else if (sourceString === JamiQmlUtils.mainViewLoadPath)
            return MainApplicationWindow.LoadedSource.MainView

        return MainApplicationWindow.LoadedSource.None
    }

    function startClient() {
        if (UtilsAdapter.getAccountListSize() !== 0) {
            mainApplicationLoader.setSource(JamiQmlUtils.mainViewLoadPath)
        } else {
            mainApplicationLoader.setSource(JamiQmlUtils.wizardViewLoadPath)
        }
    }

    function startAccountMigration() {
        mainApplicationLoader.setSource(JamiQmlUtils.accountMigrationViewLoadPath)
    }

    function close(force = false) {
        // If we're in the onboarding wizard or 'MinimizeOnClose'
        // is set, then we can quit
        if (force || !UtilsAdapter.getAppValue(Settings.MinimizeOnClose) ||
                !UtilsAdapter.getAccountListSize()) {
            Qt.quit()
        } else
            hide()
    }

    visibility: !visible ?
                   Window.Hidden : (isFullScreen ?
                                        Window.FullScreen :
                                        Window.Windowed)

    title: JamiStrings.appTitle

    flags: Qt.Window | Qt.FramelessWindowHint
    color: JamiTheme.secondaryBackgroundColor
    Atmosphere { anchors.fill: parent; z: -2 }
    Item {
        id: windowControlsOverlay
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        z: 900
        visible: !root.isFullScreen
        height: 36
        MouseArea {
            anchors.left: parent.left
            anchors.leftMargin: mainApplicationLoader.anchors.topMargin > 0 ? 12 :
                (mainApplicationLoader.item ? mainApplicationLoader.item.windowDragLeftMargin : 320)
            anchors.right: windowControls.left
            height: parent.height
            onPressed: root.startSystemMove()
            onDoubleClicked: root.visibility === Window.Maximized ? root.showNormal() : root.showMaximized()
        }
        Row {
            id: windowControls
            anchors.right: parent.right
            height: parent.height
            Repeater {
                model: 3
                Button {
                    width: 46
                    height: 36
                    Accessible.name: index === 0 ? "最小化" : index === 1 ? "最大化或还原" : "关闭"
                    contentItem: Item {
                        // All three marks share the same 12 x 12 optical box and 1px stroke.
                        Item {
                            width: 12
                            height: 12
                            anchors.centerIn: parent
                            Rectangle {
                                visible: index === 0
                                width: 12
                                height: 1
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 2
                                color: JamiTheme.textColor
                            }
                            Rectangle {
                                visible: index === 1
                                width: 10
                                height: 10
                                anchors.centerIn: parent
                                color: "transparent"
                                border.width: 1
                                border.color: JamiTheme.textColor
                            }
                            Item {
                                visible: index === 2
                                anchors.fill: parent
                                Rectangle {
                                    width: 13
                                    height: 1
                                    anchors.centerIn: parent
                                    rotation: 45
                                    color: JamiTheme.textColor
                                }
                                Rectangle {
                                    width: 13
                                    height: 1
                                    anchors.centerIn: parent
                                    rotation: -45
                                    color: JamiTheme.textColor
                                }
                            }
                        }
                    }
                    background: Rectangle {
                        radius: 7
                        anchors.margins: 3
                        color: parent.hovered ? (index === 2 ? "#b52b36" : "#225b7088") : "transparent"
                        Behavior on color { ColorAnimation { duration: 130 } }
                    }
                    onClicked: {
                        if (index === 0) root.showMinimized()
                        else if (index === 1) root.visibility === Window.Maximized ? root.showNormal() : root.showMaximized()
                        else root.close()
                    }
                }
            }
        }
    }

    // Native resize operation keeps the borderless window resizable.
    Repeater {
        parent: Overlay.overlay
        model: [Qt.LeftEdge, Qt.RightEdge, Qt.TopEdge, Qt.BottomEdge,
                Qt.LeftEdge | Qt.TopEdge, Qt.RightEdge | Qt.TopEdge,
                Qt.LeftEdge | Qt.BottomEdge, Qt.RightEdge | Qt.BottomEdge]
        MouseArea {
            z: 1000
            visible: root.visibility !== Window.Maximized && root.visibility !== Window.FullScreen
            property bool horizontalEdge: (modelData & (Qt.LeftEdge | Qt.RightEdge)) !== 0
            property bool verticalEdge: (modelData & (Qt.TopEdge | Qt.BottomEdge)) !== 0
            width: horizontalEdge ? 5 : parent.width - 10
            height: verticalEdge ? 5 : parent.height - 10
            x: (modelData & Qt.RightEdge) ? parent.width - width : horizontalEdge ? 0 : 5
            y: (modelData & Qt.BottomEdge) ? parent.height - height : verticalEdge ? 0 : 5
            cursorShape: horizontalEdge && verticalEdge ? (((modelData & Qt.LeftEdge) && (modelData & Qt.TopEdge)) || ((modelData & Qt.RightEdge) && (modelData & Qt.BottomEdge)) ? Qt.SizeFDiagCursor : Qt.SizeBDiagCursor) : horizontalEdge ? Qt.SizeHorCursor : Qt.SizeVerCursor
            onPressed: root.startSystemResize(modelData)
        }
    }

    width: {
        if (checkLoadedSource() === MainApplicationWindow.LoadedSource.WizardView)
            return JamiTheme.wizardViewMinWidth
        return JamiTheme.mainViewPreferredWidth
    }
    height: {
        if (checkLoadedSource() === MainApplicationWindow.LoadedSource.WizardView)
            return JamiTheme.wizardViewMinHeight
        return JamiTheme.mainViewPreferredHeight
    }
    minimumWidth: {
        if (checkLoadedSource() === MainApplicationWindow.LoadedSource.WizardView)
            return JamiTheme.wizardViewMinWidth
        return JamiTheme.mainViewMinWidth
    }
    minimumHeight: {
        if (checkLoadedSource() === MainApplicationWindow.LoadedSource.WizardView)
            return JamiTheme.wizardViewMinHeight
        return JamiTheme.mainViewMinHeight
    }

    visible: mainApplicationLoader.status === Loader.Ready

    // To facilitate reparenting of the callview during
    // fullscreen mode, we need QQuickItem based object.
    Item {
        id: appContainer

        anchors.fill: parent
    }

    DaemonReconnectPopup {
        id: daemonReconnectPopup
    }

    Loader {
        id: mainApplicationLoader

        anchors.fill: parent
        anchors.topMargin: root.isFullScreen ? 0 :
            (checkLoadedSource() === MainApplicationWindow.LoadedSource.MainView && item && !item.windowControlsNeedInset ? 0 : 36)
        z: -1

        asynchronous: true
        visible: status == Loader.Ready
        source: ""

        Connections {
            target: mainApplicationLoader.item

            function onLoaderSourceChangeRequested(sourceToLoad) {
                if (sourceToLoad === MainApplicationWindow.LoadedSource.WizardView)
                    mainApplicationLoader.setSource(JamiQmlUtils.wizardViewLoadPath)
                else
                    mainApplicationLoader.setSource(JamiQmlUtils.mainViewLoadPath)
            }
        }

        onLoaded: {
            // Quiet check for updates on start if set to.
            if (UtilsAdapter.getAppValue(Settings.AutoUpdate)) {
                UpdateManager.checkForUpdates(true)
                UpdateManager.setAutoUpdateCheck(true)
            }
        }
    }

    Connections {
        target: LRCInstance

        function onRestoreAppRequested() {
            requestActivate()
            if (isFullScreen)
                showFullScreen()
            else
                showNormal()
        }

        function onNotificationClicked() {
            requestActivate()
            raise()
            if (visibility === Window.Hidden ||
                    visibility === Window.Minimized) {
                if (isFullScreen)
                    showFullScreen()
                else
                    showNormal()
            }
        }
    }

    Connections {
        target: {
            if (Qt.platform.os !== "windows" && Qt.platform.os !== "macos")
                return DBusErrorHandler
            return null
        }
        ignoreUnknownSignals: true

        function onShowDaemonReconnectPopup(visible) {
            if (visible)
                daemonReconnectPopup.open()
            else
                daemonReconnectPopup.close()
        }

        function onDaemonReconnectFailed() {
            daemonReconnectPopup.connectionFailed = true
        }
    }

    onClosing: root.close()

    onScreenChanged: JamiQmlUtils.mainApplicationScreen = root.screen

    Component.onCompleted: {
        if (CurrentAccountToMigrate.accountToMigrateListSize <= 0)
            startClient()
        else
            startAccountMigration()

        JamiQmlUtils.mainApplicationScreen = root.screen

        if (Qt.platform.os !== "windows" && Qt.platform.os !== "macos")
            DBusErrorHandler.setActive(true)
    }
}
