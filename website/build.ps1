$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$html = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'index.template.html'))
$icon = [Convert]::ToBase64String([IO.File]::ReadAllBytes("$root/branding/zova/icon-256.png"))
$font = [Convert]::ToBase64String([IO.File]::ReadAllBytes("$PSScriptRoot/assets/sora-variable.ttf"))
$package = "$PSScriptRoot/public/downloads/Zova-Setup.msi"
$size = if (Test-Path $package) { '{0:N1} MB' -f ((Get-Item $package).Length / 1MB) } else { 'Windows x64' }
$html = $html.Replace('__ICON__', "data:image/png;base64,$icon").Replace('__FONT__', "data:font/ttf;base64,$font").Replace('__PACKAGE_SIZE__', $size)
[IO.File]::WriteAllText("$PSScriptRoot/public/index.html", $html, [Text.UTF8Encoding]::new($false))
Write-Output 'Built standalone public/index.html with embedded logo and variable font.'
