$ErrorActionPreference = 'Stop'
$target = Join-Path $PSScriptRoot 'public\assets\zova-hero.mp4'
New-Item -ItemType Directory -Path (Split-Path $target -Parent) -Force | Out-Null
Invoke-WebRequest -Uri 'https://zova.38-60-203-167.sslip.io/assets/zova-hero.mp4' -OutFile $target -UseBasicParsing
$hash = Get-FileHash -LiteralPath $target -Algorithm SHA256
if ($hash.Hash -ne '2698AAED2ACCD4D390B7A32866450D2BCBC8AE010EFC527C3654138BA50511ED') {
    throw "Unexpected zova-hero.mp4 checksum: $($hash.Hash)"
}
Write-Output "Downloaded and verified $target"
