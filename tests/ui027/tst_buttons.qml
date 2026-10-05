import QtQuick
import QtQuick.Controls
import QtTest
import net.jami.Constants 1.1
import "../../client-qt/src/commoncomponents" as Production

Item {
    id: scene
    width: 640
    height: 400

    Item { id: focusSink; x: 450; y: 280; width: 40; height: 40 }

    Component {
        id: materialFactory
        Production.MaterialButton {
            x: 60; y: 60; preferredWidth: 180; preferredHeight: 40
            text: "测试操作"
        }
    }

    Component {
        id: pushFactory
        Production.PushButton {
            x: 60; y: 60; preferredWidth: 180; preferredHeight: 40
            buttonText: "测试操作"
        }
    }

    Component { id: actionFactory; Action { text: "测试动作"; checkable: true } }

    Component {
        id: quickActionFactory
        Production.QuickAction {
            x: 60; y: 60; width: 360
            heading: "添加联系人"
            detail: "输入对方的用户名或识别码"
        }
    }

    SignalSpy { id: clickSpy; signalName: "clicked" }
    SignalSpy { id: actionSpy; signalName: "triggered" }
    SignalSpy { id: toggleSpy; signalName: "toggled" }

    TestCase {
        id: tests
        name: "ProductionButtons027"
        when: windowShown

        function buttonRows() {
            return [ { tag: "MaterialButton", kind: "material" },
                     { tag: "PushButton", kind: "push" } ]
        }

        function makeButton(data, properties) {
            var component = data.kind === "material" ? materialFactory : pushFactory
            var button = createTemporaryObject(component, scene, properties || {})
            verify(button !== null, "Production component must instantiate")
            clickSpy.target = button
            toggleSpy.target = button
            clickSpy.clear()
            toggleSpy.clear()
            wait(10)
            return button
        }

        function init() {
            JamiTheme.darkTheme = true
            focusSink.forceActiveFocus()
            mouseMove(scene, 600, 360)
            clickSpy.clear()
            actionSpy.clear()
            toggleSpy.clear()
        }

        function cleanup() {
            // Release any injected key or pointer state even after a failed assertion.
            keyRelease(Qt.Key_Return)
            keyRelease(Qt.Key_Enter)
            mouseRelease(scene, 600, 360, Qt.LeftButton)
            focusSink.forceActiveFocus()
            clickSpy.target = null
            toggleSpy.target = null
            actionSpy.target = null
        }

        function test_mousePressedWins_data() { return buttonRows() }
        function test_mousePressedWins(data) {
            var button = makeButton(data)
            mouseMove(button, button.width / 2, button.height / 2)
            tryCompare(button, "hovered", true)
            tryCompare(button.background, "color", Qt.color(button.hoveredColor))
            mousePress(button, button.width / 2, button.height / 2)
            verify(button.down)
            tryCompare(button.background, "color", Qt.color(button.pressedColor))
            compare(clickSpy.count, 0)
            mouseRelease(button, button.width / 2, button.height / 2)
            compare(clickSpy.count, 1)
        }

        function test_checkedStillHasPressedFeedback_data() { return buttonRows() }
        function test_checkedStillHasPressedFeedback(data) {
            var button = makeButton(data, { checkable: true, checked: true })
            mouseMove(button, button.width / 2, button.height / 2)
            mousePress(button, button.width / 2, button.height / 2)
            tryCompare(button.background, "color", Qt.color(button.pressedColor))
            mouseRelease(button, button.width / 2, button.height / 2)
            compare(button.checked, false)
            compare(clickSpy.count, 1)
        }

        function test_returnSingleRelease_data() { return buttonRows() }
        function test_returnSingleRelease(data) {
            var button = makeButton(data)
            button.forceActiveFocus(Qt.TabFocusReason)
            verify(button.activeFocus)
            keyPress(Qt.Key_Return)
            tryCompare(button.background, "color", Qt.color(button.pressedColor))
            // Repeated press events while held must never dispatch extra actions.
            keyPress(Qt.Key_Return)
            keyPress(Qt.Key_Return)
            compare(clickSpy.count, 0)
            keyRelease(Qt.Key_Return)
            compare(clickSpy.count, 1)
            keyRelease(Qt.Key_Return)
            compare(clickSpy.count, 1)
            keyClick(Qt.Key_Enter)
            compare(clickSpy.count, 2)
        }

        function test_disableCancelsHeldKey_data() { return buttonRows() }
        function test_disableCancelsHeldKey(data) {
            var button = makeButton(data)
            button.forceActiveFocus(Qt.TabFocusReason)
            keyPress(Qt.Key_Return)
            button.enabled = false
            keyRelease(Qt.Key_Return)
            compare(clickSpy.count, 0)
            compare(button.background.opacity, 0.45)
            compare(button.background.border.width, data.kind === "material" ? 1 : 0)
            mouseClick(button, button.width / 2, button.height / 2)
            compare(clickSpy.count, 0)
            button.enabled = true
            button.forceActiveFocus(Qt.TabFocusReason)
            keyRelease(Qt.Key_Return)
            compare(clickSpy.count, 0, "Re-enabling must not revive an old press")
            keyClick(Qt.Key_Return)
            compare(clickSpy.count, 1)
        }

        function test_focusLossCancelsHeldKey_data() { return buttonRows() }
        function test_focusLossCancelsHeldKey(data) {
            var button = makeButton(data)
            button.forceActiveFocus(Qt.TabFocusReason)
            keyPress(Qt.Key_Return)
            focusSink.forceActiveFocus()
            verify(!button.activeFocus)
            keyRelease(Qt.Key_Return)
            button.forceActiveFocus(Qt.TabFocusReason)
            keyRelease(Qt.Key_Return)
            compare(clickSpy.count, 0)
            keyClick(Qt.Key_Return)
            compare(clickSpy.count, 1)
        }

        function test_actionNotDuplicated_data() { return buttonRows() }
        function test_actionNotDuplicated(data) {
            var action = createTemporaryObject(actionFactory, scene)
            verify(action !== null)
            actionSpy.target = action
            actionSpy.clear()
            var button = makeButton(data, { action: action })
            button.forceActiveFocus(Qt.TabFocusReason)
            keyClick(Qt.Key_Return)
            compare(clickSpy.count, 1)
            compare(actionSpy.count, 1)
            compare(action.checked, true)
            compare(button.checked, true)
            keyClick(Qt.Key_Enter)
            compare(clickSpy.count, 2)
            compare(actionSpy.count, 2)
            compare(action.checked, false)
        }

        function test_checkableEnterTogglesOnce_data() { return buttonRows() }
        function test_checkableEnterTogglesOnce(data) {
            var button = makeButton(data, { checkable: true })
            button.forceActiveFocus(Qt.TabFocusReason)
            keyClick(Qt.Key_Return)
            compare(button.checked, true)
            compare(toggleSpy.count, 1)
            compare(clickSpy.count, 1)
        }

        function test_iconAccessibilityName_data() { return buttonRows() }
        function test_iconAccessibilityName(data) {
            var props = { toolTipText: "复制识别码" }
            props[data.kind === "material" ? "text" : "buttonText"] = ""
            var button = makeButton(data, props)
            compare(button.Accessible.name, "复制识别码")
            button[data.kind === "material" ? "text" : "buttonText"] = "复制"
            compare(button.Accessible.name, "复制")
        }

        function test_keyboardFocusRing_data() { return buttonRows() }
        function test_keyboardFocusRing(data) {
            var button = makeButton(data)
            button.forceActiveFocus(Qt.TabFocusReason)
            verify(button.visualFocus)
            compare(button.background.border.width, 2)
            focusSink.forceActiveFocus()
            verify(!button.visualFocus)
            compare(button.background.border.width, data.kind === "material" ? 1 : 0)
        }

        function test_outlinedPressedContent() {
            var button = makeButton({ kind: "material" }, { outlined: true })
            mouseMove(button, button.width / 2, button.height / 2)
            mousePress(button, button.width / 2, button.height / 2)
            compare(button.contentColorProvider, String(button.pressedColor))
            compare(button.background.border.color, Qt.color(button.pressedColor))
            mouseRelease(button, button.width / 2, button.height / 2)
        }

        function quickActionRows() {
            return [ { tag: "dark", dark: true }, { tag: "light", dark: false } ]
        }

        function test_quickActionThemeAndSize_data() { return quickActionRows() }
        function test_quickActionThemeAndSize(data) {
            JamiTheme.darkTheme = data.dark
            var button = createTemporaryObject(quickActionFactory, scene)
            verify(button !== null)
            compare(button.height, 76)
            compare(button.width, 360)
            compare(button.Accessible.name, "添加联系人")
            compare(button.Accessible.description, "输入对方的用户名或识别码")
            compare(button.background.color, Qt.color("transparent"))
            mouseMove(button, button.width / 2, button.height / 2)
            tryCompare(button, "hovered", true)
            tryCompare(button.background, "color", Qt.color(data.dark ? "#1a2837" : "#e9f1f7"))
            mousePress(button, button.width / 2, button.height / 2)
            tryCompare(button.background, "color", Qt.color(data.dark ? "#22364a" : "#dae8f3"))
            mouseRelease(button, button.width / 2, button.height / 2)
            // StrongFocus retains the mouse focus reason until focus actually moves.
            focusSink.forceActiveFocus()
            button.forceActiveFocus(Qt.TabFocusReason)
            compare(button.background.border.color, Qt.color(data.dark ? "#9dc9ed" : "#316991"))
            compare(button.contentItem.children[0].color, data.dark ? "#a9c7df" : "#355f7e")
            compare(button.contentItem.children[1].children[0].color, JamiTheme.textColor)
            verify(button.contentItem.children[1].width > 0)
        }

        function test_quickActionKeyboardAndDisabled_data() { return quickActionRows() }
        function test_quickActionKeyboardAndDisabled(data) {
            JamiTheme.darkTheme = data.dark
            var button = createTemporaryObject(quickActionFactory, scene)
            verify(button !== null)
            clickSpy.target = button
            clickSpy.clear()
            button.forceActiveFocus(Qt.TabFocusReason)
            keyClick(Qt.Key_Return)
            compare(clickSpy.count, 1)
            keyClick(Qt.Key_Enter)
            compare(clickSpy.count, 2)
            button.enabled = false
            compare(button.opacity, 0.45)
            keyClick(Qt.Key_Return)
            mouseClick(button, button.width / 2, button.height / 2)
            compare(clickSpy.count, 2)
        }
    }
}
