param(
    [string]$Source = 'D:\Liaodanwang\client-qt\resources\images\zova-transparent.png',
    [string]$Output = 'D:\Liaodanwang\client-qt\resources\images\jami.ico',
    [string]$Preview = 'D:\Liaodanwang\packaging\generated\zova-icon-preview.png'
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$sourceBitmap = [Drawing.Bitmap]::FromFile($Source)
$sizes = @(16, 24, 32, 48, 64, 128, 256)
$frames = New-Object System.Collections.Generic.List[byte[]]

try {
    # The transparent master is a horizontal wordmark. This rectangle isolates the Z mark.
    $crop = New-Object Drawing.Rectangle(195, 82, 590, 590)
    foreach ($size in $sizes) {
        $bitmap = New-Object Drawing.Bitmap($size, $size, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
        $graphics = [Drawing.Graphics]::FromImage($bitmap)
        try {
            $graphics.Clear([Drawing.Color]::Transparent)
            $graphics.SmoothingMode = [Drawing.Drawing2D.SmoothingMode]::AntiAlias
            $graphics.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.PixelOffsetMode = [Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            $padding = [Math]::Max(1, [Math]::Round($size * 0.08))
            $contentSize = $size - (2 * $padding)
            $destination = New-Object Drawing.Rectangle($padding, $padding, $contentSize, $contentSize)
            $graphics.DrawImage($sourceBitmap, $destination, $crop, [Drawing.GraphicsUnit]::Pixel)
            $stream = New-Object IO.MemoryStream
            $bitmap.Save($stream, [Drawing.Imaging.ImageFormat]::Png)
            $frames.Add($stream.ToArray())
            $stream.Dispose()
            if ($size -eq 256) {
                New-Item -ItemType Directory -Path (Split-Path $Preview -Parent) -Force | Out-Null
                $bitmap.Save($Preview, [Drawing.Imaging.ImageFormat]::Png)
            }
        } finally {
            $graphics.Dispose()
            $bitmap.Dispose()
        }
    }
} finally {
    $sourceBitmap.Dispose()
}

New-Item -ItemType Directory -Path (Split-Path $Output -Parent) -Force | Out-Null
$file = [IO.File]::Open($Output, [IO.FileMode]::Create, [IO.FileAccess]::Write)
$writer = New-Object IO.BinaryWriter($file)
try {
    $writer.Write([uint16]0)
    $writer.Write([uint16]1)
    $writer.Write([uint16]$sizes.Count)
    $offset = 6 + 16 * $sizes.Count
    for ($index = 0; $index -lt $sizes.Count; $index++) {
        $size = $sizes[$index]
        $writer.Write([byte]($(if ($size -eq 256) { 0 } else { $size })))
        $writer.Write([byte]($(if ($size -eq 256) { 0 } else { $size })))
        $writer.Write([byte]0)
        $writer.Write([byte]0)
        $writer.Write([uint16]1)
        $writer.Write([uint16]32)
        $writer.Write([uint32]$frames[$index].Length)
        $writer.Write([uint32]$offset)
        $offset += $frames[$index].Length
    }
    foreach ($frame in $frames) { $writer.Write($frame) }
} finally {
    $writer.Dispose()
    $file.Dispose()
}

Write-Output "Transparent Windows icon written to $Output"
