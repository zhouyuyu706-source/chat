/*
 * Copyright (C) 2020-2021 by Savoir-faire Linux
 * Author: Mingrui Zhang <mingrui.zhang@savoirfairelinux.com>
 * Author: Andreas Traczyk <andreas.traczyk@savoirfairelinux.com>
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
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import net.jami.Models 1.1
import net.jami.Adapters 1.1
import net.jami.Constants 1.1

import "../../commoncomponents"

Rectangle {
    id: sidePanelRect
    readonly property bool searchNeedsEscape: contactSearchBar.editing && contactSearchBar.textContent.length > 0

    color: JamiTheme.darkTheme ? "#121821" : JamiTheme.backgroundColor
    radius: 22
    border.width: 1
    border.color: JamiTheme.darkTheme ? "#25313e" : "#d7e2eb"
    layer.enabled: true
    layer.effect: DropShadow { verticalOffset: 5; radius: 14; color: "#65030910"; transparentBorder: true }

    anchors.fill: parent

    ColumnLayout {
        anchors.centerIn: parent
        visible: !conversationListView.count && !searchResultsListView.count && !contactSearchBar.textContent
        spacing: 18
        ResponsiveImage {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            source: JamiResources.chat_black_24dp_svg
            color: JamiTheme.darkTheme ? "#697582" : "#8894a0"
        }
        Text { Layout.alignment: Qt.AlignHCenter; text: "开启一段新对话"; color: JamiTheme.darkTheme ? "#a8b5c6" : JamiTheme.textColor; font.pixelSize: 13 }
        MaterialButton {
            Layout.alignment: Qt.AlignHCenter
            text: "+  添加联系人"
            cornerRadius: 24
            preferredWidth: 150
            preferredHeight: 40
            onClicked: contactSearchBar.focusSearch()
        }
    }

    Connections {
        target: LRCInstance

        function onCurrentAccountIdChanged() {
            clearContactSearchBar()
        }
    }

    Connections {
        target: ConversationsAdapter

        function onConversationReady() {
            selectTab(SidePanelTabBar.Conversations)
            clearContactSearchBar()
        }
    }

    function clearContactSearchBar() {
        contactSearchBar.clearText()
    }

    function focusContactSearch() { contactSearchBar.focusSearch() }

    function selectTab(tabIndex) {
        sidePanelTabBar.selectTab(tabIndex)
    }

    ContactSearchBar {
        id: contactSearchBar

        height: 40
        anchors.top: sidePanelRect.top
        anchors.topMargin: 10
        anchors.left: sidePanelRect.left
        anchors.leftMargin: 15
        anchors.right: sidePanelRect.right
        anchors.rightMargin: 15

        onContactSearchBarTextChanged: function (text) {
            // not calling positionViewAtBeginning will cause
            // sort animation visual bugs
            conversationListView.positionViewAtBeginning()
            ConversationsAdapter.setFilter(text)
        }

        onReturnPressedWhileSearching: {
            var listView = searchResultsListView.count ?
                        searchResultsListView :
                        conversationListView
            if (listView.count)
                listView.model.select(0)
        }
    }

    SidePanelTabBar {
        id: sidePanelTabBar

        visible: ConversationsAdapter.pendingRequestCount &&
                 !contactSearchBar.textContent
        anchors.top: contactSearchBar.bottom
        anchors.topMargin: visible ? 10 : 0
        width: sidePanelRect.width
        height: visible ? 42 : 0
        contentHeight: visible ? 42 : 0
    }

    Rectangle {
        id: searchStatusRect

        visible: searchStatusText.text !== ""

        anchors.top: sidePanelTabBar.bottom
        anchors.topMargin: visible ? 10 : 0
        width: parent.width
        height: visible ? 42 : 0

        color: JamiTheme.backgroundColor

        Text {
            id: searchStatusText

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 32
            anchors.right: parent.right
            anchors.rightMargin: 32
            color: JamiTheme.textColor
            wrapMode: Text.WordWrap
            font.pointSize: JamiTheme.filterItemFontSize
        }
    }

    Connections {
        target: ConversationsAdapter

        function onShowSearchStatus(status) {
            searchStatusText.text = status
        }
    }

    ColumnLayout {
        id: smartListLayout

        width: parent.width
        anchors.top: searchStatusRect.bottom
        anchors.topMargin: (sidePanelTabBar.visible ||
                            searchStatusRect.visible) ? 0 : 12
        anchors.bottom: parent.bottom

        spacing: 4

        ConversationListView {
            id: searchResultsListView

            visible: count
            opacity: visible ? 1 : 0

            Layout.topMargin: 10
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.preferredHeight: visible ? contentHeight : 0
            Layout.maximumHeight: {
                var otherContentHeight = conversationListView.contentHeight + 16
                if (conversationListView.visible)
                    if (otherContentHeight < parent.height / 2)
                        return parent.height - otherContentHeight
                    else
                        return parent.height / 2
                else
                    return parent.height
            }

            model: SearchResultsListModel
            headerLabel: JamiStrings.searchResults
            headerVisible: visible
        }

        ConversationListView {
            id: conversationListView

            visible: count

            Layout.preferredWidth: parent.width
            Layout.fillHeight: true

            model: ConversationListModel
            headerLabel: JamiStrings.conversations
            headerVisible: searchResultsListView.visible
        }
    }
}
