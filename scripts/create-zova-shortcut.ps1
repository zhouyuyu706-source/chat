$ErrorActionPreference = 'Stop'
$exe = 'D:\ZovaRelease\Zova.exe'
if (!(Test-Path -LiteralPath $exe)) { throw 'Zova.exe is missing.' }
$desktop = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktop 'Zova 开发版.lnk'
if (Test-Path -LiteralPath $shortcutPath) { throw 'Existing shortcut preserved; not overwritten.' }
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $exe
$shortcut.WorkingDirectory = Split-Path $exe -Parent
$shortcut.IconLocation = "$exe,0"
$shortcut.Description = 'Zova 中文 Windows 开发版（尚未完成通信验收）'
$shortcut.Save()
Write-Output $shortcutPath
