param([string]$Destination = 'D:\ZovaRelease', [string]$ReleaseVersion = '0.2.4')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$source = Join-Path $root 'client-qt/x64/Release'
$exe = Join-Path $source 'Zova.exe'
if (!(Test-Path -LiteralPath $exe)) { throw 'No compiled Zova.exe: packaging is blocked.' }
if (Test-Path -LiteralPath $Destination) { throw 'Use a new destination to preserve previous releases.' }
$env:VSINSTALLDIR = 'D:\ZovaBuildTools\'
& 'D:\ZovaQt\6.2.1\msvc2019_64\bin\windeployqt.exe' --release --qmldir "$root/client-qt/src" --compiler-runtime $exe
if ($LASTEXITCODE -ne 0) { throw 'Qt deployment failed.' }
New-Item -ItemType Directory -Path $Destination | Out-Null
Get-ChildItem -LiteralPath $source | Where-Object { $_.Extension -notin @('.pdb','.ilk','.exp','.lib') } | Copy-Item -Destination $Destination -Recurse
Copy-Item -LiteralPath "$root/COPYING" -Destination "$Destination/COPYING"
Copy-Item -LiteralPath "$root/deployment/RELEASE-$ReleaseVersion.md" -Destination "$Destination/RELEASE-NOTES.md"
$crt = 'D:\ZovaBuildTools\VC\Redist\MSVC\14.44.35112\x64\Microsoft.VC143.CRT'
if (!(Test-Path -LiteralPath "$crt/vcruntime140.dll")) { throw 'Microsoft C++ runtime is missing; package is not portable.' }
Get-ChildItem -LiteralPath $crt -Filter '*.dll' | Copy-Item -Destination $Destination
Get-FileHash -LiteralPath "$Destination/Zova.exe" -Algorithm SHA256
Write-Output "Packaged unsigned development build in $Destination. Runtime acceptance is still required."
