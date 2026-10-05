import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import net.jami.Constants 1.1

// Compact native action row. Motion acknowledges a press, never runs while idle.
AbstractButton {
    id: control
    property string heading
    property string detail
    property string iconSource
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.role: Accessible.Button
    Accessible.name: heading
    Accessible.description: detail
    implicitHeight: 76
    opacity: enabled ? 1 : 0.45
    scale: down ? 0.993 : 1
    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
    background: Rectangle {
        radius: 12
        color: control.down ? (JamiTheme.darkTheme ? "#22364a" : "#dae8f3")
                            : control.hovered ? (JamiTheme.darkTheme ? "#1a2837" : "#e9f1f7") : "transparent"
        border.width: 1
        border.color: control.visualFocus ? (JamiTheme.darkTheme ? "#9dc9ed" : "#316991") : "transparent"
        Behavior on color { ColorAnimation { duration: 110 } }
    }
    contentItem: RowLayout {
        spacing: 14
        anchors.fill: parent
        anchors.margins: 14
        ResponsiveImage {
            source: control.iconSource
            color: JamiTheme.darkTheme ? "#a9c7df" : "#355f7e"
            Layout.preferredWidth: 22
            Layout.preferredHeight: 22
        }
        ColumnLayout {
            spacing: 5
            Layout.fillWidth: true
            Text { text: control.heading; color: JamiTheme.textColor; font.pixelSize: 14; font.weight: Font.DemiBold }
            Text { Layout.fillWidth: true; text: control.detail; color: JamiTheme.darkTheme ? "#a0adbd" : "#536777"; font.pixelSize: 12; elide: Text.ElideRight }
        }
        Text { text: "›"; color: JamiTheme.darkTheme ? "#a0adbd" : "#536777"; font.pixelSize: 22; Accessible.ignored: true }
    }
    Keys.onReturnPressed: function(event) { if (enabled && !event.isAutoRepeat) clicked(); event.accepted = true }
    Keys.onEnterPressed: function(event) { if (enabled && !event.isAutoRepeat) clicked(); event.accepted = true }
}
