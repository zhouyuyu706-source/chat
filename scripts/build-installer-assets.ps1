param(
    [string]$Icon = 'D:\Liaodanwang\branding\zova\icon.png',
    [string]$Output = 'D:\Liaodanwang\packaging\generated'
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Path $Output -Force | Out-Null

function New-Canvas([int]$Width, [int]$Height) {
    $bitmap = New-Object Drawing.Bitmap($Width, $Height)
    $graphics = [Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    return @($bitmap, $graphics)
}

$source = [Drawing.Image]::FromFile($Icon)
try {
    $main = New-Canvas 493 312
    $mainBitmap, $mainGraphics = $main
    try {
        $mainGraphics.Clear([Drawing.Color]::FromArgb(248, 250, 253))
        $panel = New-Object Drawing.Drawing2D.LinearGradientBrush(
            (New-Object Drawing.Rectangle(0, 0, 166, 312)),
            [Drawing.Color]::FromArgb(7, 18, 40),
            [Drawing.Color]::FromArgb(5, 48, 93),
            90
        )
        $mainGraphics.FillRectangle($panel, 0, 0, 166, 312)
        $panel.Dispose()
        $glow = New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(40, 26, 186, 255))
        $mainGraphics.FillEllipse($glow, -45, 42, 250, 250)
        $glow.Dispose()
        $mainGraphics.DrawImage($source, (New-Object Drawing.Rectangle(28, 50, 110, 110)))
        $brandFont = New-Object Drawing.Font('Segoe UI Semibold', 24, [Drawing.FontStyle]::Regular, [Drawing.GraphicsUnit]::Pixel)
        $metaFont = New-Object Drawing.Font('Segoe UI', 9, [Drawing.FontStyle]::Regular, [Drawing.GraphicsUnit]::Pixel)
        $white = New-Object Drawing.SolidBrush([Drawing.Color]::White)
        $muted = New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(190, 217, 239))
        $mainGraphics.DrawString('Zova', $brandFont, $white, 49, 174)
        $mainGraphics.DrawString('PRIVATE COMMUNICATION', $metaFont, $muted, 21, 215)
        $mainGraphics.DrawString('安全 · 简洁 · 自由', $metaFont, $muted, 41, 236)
        $brandFont.Dispose(); $metaFont.Dispose(); $white.Dispose(); $muted.Dispose()
        $mainBitmap.Save((Join-Path $Output 'main-banner.bmp'), [Drawing.Imaging.ImageFormat]::Bmp)
    } finally {
        $mainGraphics.Dispose(); $mainBitmap.Dispose()
    }

    $top = New-Canvas 493 58
    $topBitmap, $topGraphics = $top
    try {
        $topGraphics.Clear([Drawing.Color]::FromArgb(248, 250, 253))
        $accent = New-Object Drawing.Drawing2D.LinearGradientBrush(
            (New-Object Drawing.Rectangle(0, 0, 493, 4)),
            [Drawing.Color]::FromArgb(0, 202, 255),
            [Drawing.Color]::FromArgb(0, 80, 232),
            0
        )
        $topGraphics.FillRectangle($accent, 0, 0, 493, 4)
        $accent.Dispose()
        $topGraphics.DrawImage($source, (New-Object Drawing.Rectangle(421, 9, 40, 40)))
        $topFont = New-Object Drawing.Font('Segoe UI Semibold', 14, [Drawing.FontStyle]::Regular, [Drawing.GraphicsUnit]::Pixel)
        $navy = New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(13, 38, 70))
        $topGraphics.DrawString('Zova', $topFont, $navy, 376, 20)
        $topFont.Dispose(); $navy.Dispose()
        $topBitmap.Save((Join-Path $Output 'top-banner.bmp'), [Drawing.Imaging.ImageFormat]::Bmp)
    } finally {
        $topGraphics.Dispose(); $topBitmap.Dispose()
    }
} finally {
    $source.Dispose()
}

Write-Output "Installer artwork written to $Output"
