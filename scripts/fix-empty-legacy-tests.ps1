$ErrorActionPreference = 'Stop'
$path = Join-Path $PSScriptRoot '../client-android/ring-android/libringclient/src/test/java/net/jami/model/ConversationTest.kt'
$s = [IO.File]::ReadAllText($path)
# Empty Kotlin property getters were never executable JUnit tests. Remove
# only empty scaffolding; all tests containing assertions remain intact.
$s = [regex]::Replace($s, '(?m)^    @get:Throws\(Exception::class\)\r?\n    @get:Test\r?\n    val \w+: Unit\r?\n        get\(\) \{\}\r?\n', '')
$s = [regex]::Replace($s, '(?m)^    @Test\r?\n    @Throws\(Exception::class\)\r?\n    fun \w+\(\) \{\r?\n    \}\r?\n', '')
[IO.File]::WriteAllText($path, $s, [Text.UTF8Encoding]::new($false))
