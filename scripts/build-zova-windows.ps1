param([string]$Sdk = '10.0.26100.0', [string]$Toolset = '143')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$env:QT_ROOT_DIRECTORY = 'D:\ZovaQt'
$env:ZOVA_BASH = 'C:\msys64\usr\bin\bash.exe'
$env:ZOVA_YASM_CUSTOMIZATIONS = 'D:\ZovaBuildDeps\VSYASM'
$env:ZOVA_NASM_CUSTOMIZATIONS = 'D:\ZovaBuildDeps\VSNASM'
$env:YASMPATH = 'C:\msys64\usr\bin\'
$env:NASMPATH = 'C:\msys64\usr\bin\'
$cmakeBin = 'D:\ZovaBuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin'
$env:PATH = "$cmakeBin;D:\ZovaBuildEnv\Scripts;C:\Strawberry\perl\bin;C:\msys64\usr\bin;" + $env:PATH
foreach ($file in @("$cmakeBin\cmake.exe", 'C:\Strawberry\perl\bin\perl.exe', $env:ZOVA_BASH,
    'D:\ZovaQt\6.2.1\msvc2019_64\bin\qmake.exe',
    'D:\ZovaBuildTools\VC\Tools\MSVC\14.44.35207\atlmfc\include\atlbase.h')) {
    if (!(Test-Path -LiteralPath $file)) { throw "Missing build dependency: $file" }
}
function RunStep([string]$Directory, [scriptblock]$Command) {
    Push-Location $Directory
    try { & $Command; if ($LASTEXITCODE -ne 0) { throw "Build failed in $Directory (exit $LASTEXITCODE)" } }
    finally { Pop-Location }
}
RunStep "$root/daemon/compat/msvc" { python winmake.py -b daemon -s $Sdk -t $Toolset }
RunStep "$root/lrc" { python make-lrc.py -g -b -q 6.2.1 -s $Sdk -t $Toolset }
RunStep "$root/client-qt" { python make-client.py -q 6.2.1 }
$exe = "$root/client-qt/x64/Release/Zova.exe"
if (!(Test-Path -LiteralPath $exe)) { throw 'Build produced no Zova.exe' }
Write-Output "Built: $exe. Packaging and runtime acceptance still required."
