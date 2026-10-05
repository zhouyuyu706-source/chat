param(
    [Parameter(Mandatory=$true)][string]$Wordmark,
    [Parameter(Mandatory=$true)][string]$Icon,
    [string]$Root = (Split-Path $PSScriptRoot -Parent)
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$brand = Join-Path $Root 'branding/zova'
New-Item -ItemType Directory -Force -Path $brand | Out-Null
Copy-Item -LiteralPath $Wordmark -Destination "$brand/wordmark.png"
Copy-Item -LiteralPath $Icon -Destination "$brand/icon.png"
$utf8 = New-Object System.Text.UTF8Encoding($false)
function SvgWrapper($InputPath, $OutputPath) {
    $img = [Drawing.Image]::FromFile($InputPath)
    try {
        $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($InputPath))
        $svg = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="{0}" height="{1}" viewBox="0 0 {0} {1}"><image width="{0}" height="{1}" xlink:href="data:image/png;base64,{2}"/></svg>' -f $img.Width,$img.Height,$b64
        [IO.File]::WriteAllText($OutputPath,$svg,$utf8)
    } finally { $img.Dispose() }
}
function ResizePng($InputPath,$OutputPath,[int]$Size) {
    $src = [Drawing.Image]::FromFile($InputPath)
    $bmp = New-Object Drawing.Bitmap($Size,$Size)
    $g = [Drawing.Graphics]::FromImage($bmp)
    try {
        $g.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.DrawImage($src,0,0,$Size,$Size)
        $bmp.Save($OutputPath,[Drawing.Imaging.ImageFormat]::Png)
    } finally { $g.Dispose(); $bmp.Dispose(); $src.Dispose() }
}
$qt = "$Root/client-qt/resources/images"
foreach ($name in @('logo-jami-standard-coul.svg','logo-jami-standard-coul-white.svg')) {
    SvgWrapper "$brand/wordmark.png" "$qt/$name"
}
foreach ($name in @('jami.svg','jami-new.svg')) { SvgWrapper "$brand/icon.png" "$qt/$name" }
ResizePng "$brand/icon.png" "$qt/jami-48px.png" 48
# Windows ICO with a 256px PNG payload; generated artwork is only resized.
$tempPng = "$brand/icon-256.png"
ResizePng "$brand/icon.png" $tempPng 256
$bytes = [IO.File]::ReadAllBytes($tempPng)
$stream = [IO.File]::Create("$qt/jami.ico")
$writer = New-Object IO.BinaryWriter($stream)
try {
    $writer.Write([uint16]0); $writer.Write([uint16]1); $writer.Write([uint16]1)
    $writer.Write([byte]0); $writer.Write([byte]0); $writer.Write([byte]0); $writer.Write([byte]0)
    $writer.Write([uint16]1); $writer.Write([uint16]32)
    $writer.Write([uint32]$bytes.Length); $writer.Write([uint32]22); $writer.Write($bytes)
} finally { $writer.Dispose() }
$res = "$Root/client-android/ring-android/app/src/main/res"
$sizes = @{mdpi=48;hdpi=72;xhdpi=96;xxhdpi=144;xxxhdpi=192}
foreach ($density in $sizes.Keys) {
    ResizePng "$brand/icon.png" "$res/mipmap-$density/ic_launcher.png" $sizes[$density]
    ResizePng "$brand/icon.png" "$res/mipmap-$density/ic_launcher_foreground.png" ([int]($sizes[$density]*2.25))
    ResizePng "$brand/icon.png" "$res/drawable-$density/ic_ring_logo_white.png" $sizes[$density]
}
Copy-Item "$brand/wordmark.png" "$res/drawable/zova_wordmark.png"
Copy-Item "$brand/icon-256.png" "$res/drawable/zova_icon.png"
foreach ($name in @('ic_jami_full_logo','ic_ring_logo_white_vd','ic_jami','ic_jami_24','ic_jami_48')) {
    $drawable = if ($name -eq 'ic_jami_full_logo') { 'zova_wordmark' } else { 'zova_icon' }
    [IO.File]::WriteAllText("$res/drawable/$name.xml", ('<?xml version="1.0" encoding="utf-8"?><bitmap xmlns:android="http://schemas.android.com/apk/res/android" android:src="@drawable/{0}" android:gravity="fill" />' -f $drawable), $utf8)
}
$ios = "$Root/client-ios/Ring/Ring/Resources/Images.xcassets"
$catalog = Get-Content "$ios/AppIcon.appiconset/Contents.json" -Raw | ConvertFrom-Json
foreach ($entry in $catalog.images) {
    if ($entry.filename) {
        $size = [int]([double]($entry.size.Split('x')[0]) * [double]($entry.scale.TrimEnd('x')))
        ResizePng "$brand/icon.png" "$ios/AppIcon.appiconset/$($entry.filename)" $size
    }
}
Get-ChildItem "$ios/ring_logo.imageset" -Filter '*.png' | ForEach-Object { Copy-Item "$brand/wordmark.png" $_.FullName }
# ICNS supports PNG payloads for the 1024px ic10 element.
$macPng = "$brand/icon-1024.png"
ResizePng "$brand/icon.png" $macPng 1024
$macBytes = [IO.File]::ReadAllBytes($macPng)
function BigEndian([uint32]$Value) {
    $data = [BitConverter]::GetBytes($Value)
    if ([BitConverter]::IsLittleEndian) { [Array]::Reverse($data) }
    return ,$data
}
$macStream = [IO.File]::Create("$qt/jami.icns")
$macWriter = New-Object IO.BinaryWriter($macStream)
try {
    $macWriter.Write([Text.Encoding]::ASCII.GetBytes('icns'))
    $macWriter.Write((BigEndian ($macBytes.Length + 16)))
    $macWriter.Write([Text.Encoding]::ASCII.GetBytes('ic10'))
    $macWriter.Write((BigEndian ($macBytes.Length + 8)))
    $macWriter.Write($macBytes)
} finally { $macWriter.Dispose() }
Copy-Item "$qt/jami.icns" "$Root/client-macosx/data/appicon.icns"
Copy-Item "$brand/wordmark.png" "$Root/client-macosx/data/logo_white.png"
Write-Output 'Zova artwork generated for desktop, Android and Apple clients.'
