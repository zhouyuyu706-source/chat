pragma Singleton
import QtQuick

// Test-only service boundary. Production button QML is imported unchanged.
QtObject {
    property bool darkTheme: true
    property int primaryRadius: 8
    property int preferredMarginSize: 12
    property int shortFadeDuration: 80
    property color buttonTintedBlue: "#126d9c"
    property color buttonTintedBlueHovered: "#0d608c"
    property color buttonTintedBluePressed: "#0b5176"
    property color pressedButtonColor: "#526374"
    property color hoveredButtonColor: "#34495b"
    property color normalButtonColor: "#233444"
    property color primaryForegroundColor: darkTheme ? "#edf3f8" : "#162535"
    property color textColor: primaryForegroundColor
    property color transparentColor: "transparent"
}
