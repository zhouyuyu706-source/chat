param([Parameter(Mandatory=$true)][string]$Payload, [string]$Output='D:\ZovaInstallers\Zova-0.2.1-x64-candidate.msi', [string]$Version='0.2.1')
$ErrorActionPreference='Stop'
$wix='D:\ZovaBuildDeps\WiX3141'
$root=Split-Path $PSScriptRoot -Parent
if (!(Test-Path "$Payload\Zova.exe")) { throw 'Missing application payload' }
if (Test-Path $Output) { throw 'Existing installer preserved. Choose a new output.' }
& "$PSScriptRoot\build-windows-icon.ps1"
Copy-Item -LiteralPath "$root\client-qt\resources\images\jami.ico" -Destination "$Payload\jami.ico" -Force
& "$PSScriptRoot\build-installer-assets.ps1"
$build=Join-Path ([IO.Path]::GetTempPath()) ('zova-msi-'+[guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $build | Out-Null
New-Item -ItemType Directory -Path (Split-Path $Output -Parent) -Force | Out-Null
& "$wix\heat.exe" dir $Payload -nologo -ag -srd -sreg -sfrag -cg ZovaPayload -dr APPLICATIONFOLDER -var var.Payload -out "$build\Payload.wxs"
if ($LASTEXITCODE) { throw 'Payload harvest failed' }
& "$wix\candle.exe" -nologo -arch x64 "-dPayload=$Payload" "-dAppVersion=$Version" "-dInstallerAssets=$root\packaging\generated" -out "$build\" "$root\packaging\ZovaWindows.wxs" "$build\Payload.wxs"
if ($LASTEXITCODE) { throw 'Installer compilation failed' }
& "$wix\light.exe" -nologo -ext WixUIExtension -cultures:zh-cn -out "$build\validated.msi" "$build\ZovaWindows.wixobj" "$build\Payload.wixobj"
if ($LASTEXITCODE) { throw 'Installer validation/link failed' }
Copy-Item -LiteralPath "$build\validated.msi" -Destination $Output
Get-FileHash $Output -Algorithm SHA256
Write-Output 'Unsigned test installer. Install, upgrade, uninstall and communication acceptance still required.'
