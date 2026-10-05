import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import net.jami.Constants 1.1

AbstractButton {
    id: control
    property string heading
    property string detail
    property string actionText
    property string iconSource
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    Accessible.name: heading + "，" + actionText
    implicitHeight: 186
    scale: down ? 0.985 : hovered ? 1.012 : 1
    Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
    transform: Rotation {
        origin.x: control.width / 2
        origin.y: control.height / 2
        axis.x: 1; axis.y: 0; axis.z: 0
        angle: control.hovered && !control.down ? 1.5 : 0
        Behavior on angle { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    }
    background: Rectangle {
        id: surface
        radius: 20
        border.width: 1
        border.color: control.activeFocus ? "#99c7ef" : control.hovered ? "#557490b0" : "#233e526c"
        Behavior on border.color { ColorAnimation { duration: 220 } }
        gradient: Gradient {
            GradientStop { position: 0; color: JamiTheme.darkTheme ? (control.hovered ? "#203043" : "#182332") : "#ffffff" }
            GradientStop { position: 1; color: JamiTheme.darkTheme ? "#0f1722" : "#e6f0f7" }
        }
        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: control.hovered ? 10 : 5
            radius: control.hovered ? 24 : 18
            color: "#65040912"
            transparentBorder: true
        }
        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 1
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 38
            height: 1
            opacity: control.hovered ? 0.65 : 0.3
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: "transparent" }
                GradientStop { position: 0.5; color: "#b1cbe4" }
                GradientStop { position: 1; color: "transparent" }
            }
        }
    }
    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12
        RowLayout {
            spacing: 10
            Rectangle {
                Layout.preferredWidth: 34; Layout.preferredHeight: 34
                radius: 10
                color: JamiTheme.darkTheme ? "#23344a" : "#e5edf6"
                border.color: JamiTheme.darkTheme ? "#314761" : "#d6e2ef"
                ResponsiveImage { anchors.centerIn: parent; source: control.iconSource; color: JamiTheme.darkTheme ? "#b4d5f4" : "#345f85"; width: 19; height: 19 }
            }
            Text { text: control.heading; color: JamiTheme.textColor; font.pixelSize: 14; font.weight: Font.DemiBold }
        }
        Text { Layout.fillWidth: true; Layout.fillHeight: true; text: control.detail; color: JamiTheme.darkTheme ? "#9aaabd" : "#536777"; wrapMode: Text.WordWrap; font.pixelSize: 12; lineHeight: 1.5 }
        RowLayout {
            Layout.fillWidth: true
            Text { Layout.fillWidth: true; text: control.actionText; color: JamiTheme.darkTheme ? "#bbd8f0" : "#345f85"; font.pixelSize: 12 }
            Text { text: "↗"; color: JamiTheme.darkTheme ? "#bbd8f0" : "#345f85"; font.pixelSize: 17; opacity: control.hovered ? 1 : 0.5; Behavior on opacity { NumberAnimation { duration: 180 } } }
        }
    }
    Keys.onReturnPressed: clicked()
    Keys.onEnterPressed: clicked()
}
