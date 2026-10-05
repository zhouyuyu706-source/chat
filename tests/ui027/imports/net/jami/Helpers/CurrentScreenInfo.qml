pragma Singleton
import QtQuick

// ResponsiveImage only needs the screen-density notification in these tests.
QtObject {
    property real devicePixelRatio: 1
}
