# Zova 0.2.7 button regression tests

Run `powershell -ExecutionPolicy Bypass -File D:\Liaodanwang\tests\ui027\run.ps1`.

The runner uses Qt Quick Test 6.2.1 with `-platform offscreen` and the software renderer. It does not drive the user's desktop or connect to a server. The tests import MaterialButton.qml and PushButton.qml directly from the production source directory. The small Constants and Helpers modules here are test-only service stubs, not replacements for production modules.

Coverage: hovered/pressed priority, checked/pressed priority, Enter and Return single-release activation, repeated press events, disabled and lost-focus cancellation, Action forwarding, checkable state, accessible icon names, and keyboard focus borders. A separate outlined MaterialButton check covers text and border feedback.

QuickAction is also imported directly and tested in both dark and light themes for hover/pressed/focus colors, text contrast tokens, basic dimensions, keyboard activation and disabled click protection. The runner starts a hidden offscreen subprocess, waits for completion and restores its environment overrides.

`results.txt` is the most recent run. This is behavioral regression coverage, not a screenshot, GPU-rendering, screen-reader, or full application integration acceptance test. Repeated injected key presses exercise single-release dispatch; Qt Quick Test's public key API does not expose the OS auto-repeat flag.
