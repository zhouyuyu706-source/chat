import QtQuick
import Qt5Compat.GraphicalEffects
import net.jami.Constants 1.1

// A restrained depth field for the main workspace. Large, low-contrast layers
// move at different speeds to create parallax without competing with content.
Item {
    id: root
    clip: true

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: JamiTheme.darkTheme ? "#0d121c" : "#f5f8fb" }
            GradientStop { position: 0.52; color: JamiTheme.darkTheme ? "#0b111a" : "#edf4f8" }
            GradientStop { position: 1.0; color: JamiTheme.darkTheme ? "#101c2a" : "#dceaf3" }
        }
    }

    Item {
        id: farField
        width: root.width * 1.34
        height: root.height * 1.34
        x: -root.width * 0.23
        y: -root.height * 0.13

        RadialGradient {
            anchors.fill: parent
            horizontalOffset: -width * 0.27
            verticalOffset: height * 0.24
            horizontalRadius: width * 0.66
            verticalRadius: height * 0.52
            gradient: Gradient {
                GradientStop { position: 0.0; color: JamiTheme.darkTheme ? "#3822577b" : "#385ba8ce" }
                GradientStop { position: 0.52; color: JamiTheme.darkTheme ? "#171f4867" : "#17488fb5" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        SequentialAnimation on x {
            running: root.visible
            loops: Animation.Infinite
            NumberAnimation { to: -root.width * 0.12; duration: 15000; easing.type: Easing.InOutSine }
            NumberAnimation { to: -root.width * 0.23; duration: 17000; easing.type: Easing.InOutSine }
        }
        SequentialAnimation on y {
            running: root.visible
            loops: Animation.Infinite
            NumberAnimation { to: -root.height * 0.20; duration: 19000; easing.type: Easing.InOutSine }
            NumberAnimation { to: -root.height * 0.13; duration: 16000; easing.type: Easing.InOutSine }
        }
    }

    Item {
        id: nearField
        width: root.width * 1.28
        height: root.height * 1.28
        x: -root.width * 0.02
        y: -root.height * 0.24

        RadialGradient {
            anchors.fill: parent
            horizontalOffset: width * 0.32
            verticalOffset: -height * 0.18
            horizontalRadius: width * 0.58
            verticalRadius: height * 0.48
            gradient: Gradient {
                GradientStop { position: 0.0; color: JamiTheme.darkTheme ? "#24366c86" : "#326ca9c5" }
                GradientStop { position: 0.58; color: JamiTheme.darkTheme ? "#121d4058" : "#164878a0" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        SequentialAnimation on x {
            running: root.visible
            loops: Animation.Infinite
            NumberAnimation { to: -root.width * 0.13; duration: 11000; easing.type: Easing.InOutSine }
            NumberAnimation { to: -root.width * 0.02; duration: 13000; easing.type: Easing.InOutSine }
        }
        SequentialAnimation on y {
            running: root.visible
            loops: Animation.Infinite
            NumberAnimation { to: -root.height * 0.12; duration: 14000; easing.type: Easing.InOutSine }
            NumberAnimation { to: -root.height * 0.24; duration: 12000; easing.type: Easing.InOutSine }
        }
    }

    // A very soft angled plane makes the two light fields read as depth rather
    // than as separate decorative circles.
    LinearGradient {
        width: root.width * 0.82
        height: root.height * 1.5
        x: root.width * 0.18
        y: -root.height * 0.25
        rotation: -18
        opacity: JamiTheme.darkTheme ? 0.22 : 0.14
        start: Qt.point(0, 0)
        end: Qt.point(width, height)
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.47; color: JamiTheme.darkTheme ? "#142e5874" : "#205886a4" }
            GradientStop { position: 0.58; color: "transparent" }
        }

        SequentialAnimation on opacity {
            running: root.visible
            loops: Animation.Infinite
            NumberAnimation { to: JamiTheme.darkTheme ? 0.30 : 0.19; duration: 9000; easing.type: Easing.InOutSine }
            NumberAnimation { to: JamiTheme.darkTheme ? 0.18 : 0.12; duration: 11000; easing.type: Easing.InOutSine }
        }
    }

    // Cinematic volume inspired by the landing page: no wireframes or neon
    // geometry, only layered material, a cool rim and a warmer reflected edge.
    Item {
        id: depthOrb
        width: Math.min(root.width, root.height) * 0.92
        height: width
        x: root.width - width * 0.70
        y: root.height * 0.04
        opacity: JamiTheme.darkTheme ? 0.86 : 0.54
        transformOrigin: Item.Center

        RadialGradient {
            anchors.fill: parent
            horizontalOffset: -width * 0.16
            verticalOffset: -height * 0.20
            horizontalRadius: width * 0.54
            verticalRadius: height * 0.54
            gradient: Gradient {
                GradientStop { position: 0.0; color: JamiTheme.darkTheme ? "#6687bdd3" : "#708fc7dc" }
                GradientStop { position: 0.18; color: JamiTheme.darkTheme ? "#465f9fba" : "#526dacbf" }
                GradientStop { position: 0.50; color: JamiTheme.darkTheme ? "#242c5f80" : "#303f718e" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        RadialGradient {
            anchors.fill: parent
            horizontalOffset: width * 0.25
            verticalOffset: height * 0.22
            horizontalRadius: width * 0.48
            verticalRadius: height * 0.44
            gradient: Gradient {
                GradientStop { position: 0.0; color: JamiTheme.darkTheme ? "#2f1f3653" : "#33566c82" }
                GradientStop { position: 0.30; color: JamiTheme.darkTheme ? "#252f5a74" : "#384f7a88" }
                GradientStop { position: 0.70; color: JamiTheme.darkTheme ? "#16284770" : "#24476476" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        RadialGradient {
            anchors.fill: parent
            horizontalOffset: width * 0.34
            verticalOffset: -height * 0.30
            horizontalRadius: width * 0.44
            verticalRadius: height * 0.38
            gradient: Gradient {
                GradientStop { position: 0.0; color: JamiTheme.darkTheme ? "#3071a9c2" : "#3b72a6c4" }
                GradientStop { position: 0.34; color: JamiTheme.darkTheme ? "#183d6b85" : "#214f778b" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        SequentialAnimation on x {
            running: root.visible
            loops: Animation.Infinite
            NumberAnimation { to: root.width - depthOrb.width * 0.78; duration: 13000; easing.type: Easing.InOutSine }
            NumberAnimation { to: root.width - depthOrb.width * 0.66; duration: 15000; easing.type: Easing.InOutSine }
        }
        SequentialAnimation on y {
            running: root.visible
            loops: Animation.Infinite
            NumberAnimation { to: root.height * 0.12; duration: 11000; easing.type: Easing.InOutSine }
            NumberAnimation { to: root.height * 0.02; duration: 14000; easing.type: Easing.InOutSine }
        }
        SequentialAnimation on scale {
            running: root.visible
            loops: Animation.Infinite
            NumberAnimation { to: 1.06; duration: 9000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.98; duration: 11000; easing.type: Easing.InOutSine }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: JamiTheme.darkTheme ? "#121f3042" : "#183b647a"
    }
}
