import QtQuick
import net.jami.Constants 1.1

// Transparent ribbon asset plus native wordmark avoids a rectangular banner.
Item {
    property string source: ""
    Item {
        id: mark
        width: parent.height
        height: parent.height
        clip: true
        Image {
            source: "qrc:/images/zova-transparent.png"
            width: mark.width * 3.65
            height: width / 3
            x: -mark.width * 0.35
            y: -mark.height * 0.15
            smooth: true
            mipmap: true
        }
    }
    Text {
        anchors.left: mark.right
        anchors.leftMargin: parent.height * 0.12
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: "Zova"
        color: JamiTheme.darkTheme ? "#ffffff" : "#142536"
        font.family: "Segoe UI"
        font.weight: Font.DemiBold
        font.italic: false
        font.letterSpacing: -1.5
        font.pixelSize: parent.height * 0.78
        fontSizeMode: Text.Fit
        minimumPixelSize: 18
    }
}
