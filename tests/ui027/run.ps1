param([string]$QtBin = 'D:\ZovaQt\6.2.1\msvc2019_64\bin')
$ErrorActionPreference = 'Stop'
$testRoot = $PSScriptRoot
$previousPath = $env:PATH
$previousBackend = $env:QT_QUICK_BACKEND
$previousConsoleLogging = $env:QT_LOGGING_TO_CONSOLE
$previousStderrConsole = $env:QT_ASSUME_STDERR_HAS_CONSOLE
$previousFontDirectory = $env:QT_QPA_FONTDIR
try {
    $env:PATH = $QtBin + ';' + $env:PATH
    $env:QT_QUICK_BACKEND = 'software'
    $env:QT_LOGGING_TO_CONSOLE = '1'
    $env:QT_ASSUME_STDERR_HAS_CONSOLE = '1'
    $env:QT_QPA_FONTDIR = Join-Path $env:WINDIR 'Fonts'
    $runnerArguments = '-platform offscreen -input "{0}" -import "{1}" -o "{2},txt"' -f (Join-Path $testRoot 'tst_buttons.qml'), (Join-Path $testRoot 'imports'), (Join-Path $testRoot 'results.txt')
    $testProcess = Start-Process -FilePath (Join-Path $QtBin 'qmltestrunner.exe') -ArgumentList $runnerArguments -WindowStyle Hidden -RedirectStandardError (Join-Path $testRoot 'stderr.txt') -RedirectStandardOutput (Join-Path $testRoot 'stdout.txt') -PassThru
    $testProcess.WaitForExit()
    $testExit = $testProcess.ExitCode
    Get-Content -LiteralPath (Join-Path $testRoot 'results.txt')
    exit $testExit
} finally {
    $env:PATH = $previousPath
    $env:QT_QUICK_BACKEND = $previousBackend
    $env:QT_LOGGING_TO_CONSOLE = $previousConsoleLogging
    $env:QT_ASSUME_STDERR_HAS_CONSOLE = $previousStderrConsole
    $env:QT_QPA_FONTDIR = $previousFontDirectory
}
