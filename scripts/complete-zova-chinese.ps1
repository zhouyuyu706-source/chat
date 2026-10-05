$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$map = Get-Content "$root/branding/zova/zh-CN-completion.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$path = "$root/client-qt/translations/ring_client_windows_zh_CN.ts"
$content = [IO.File]::ReadAllText($path)
$updated = [regex]::Replace($content, '(?s)<message\b[^>]*>.*?</message>', {
    param($match)
    [xml]$node = $match.Value
    $key = $node.message.SelectSingleNode('source').InnerText
    $entry = $map.PSObject.Properties[$key]
    if ($null -eq $entry) { return $match.Value }
    $escaped = [Security.SecurityElement]::Escape([string]$entry.Value)
    [regex]::Replace($match.Value, '(?s)<translation\b[^>]*(?:/>|>.*?</translation>)', "<translation>$escaped</translation>")
})
[IO.File]::WriteAllText($path,$updated,(New-Object Text.UTF8Encoding($false)))
[xml]$check = $updated
$missing = $check.SelectNodes('//message[normalize-space(source) and (translation/@type="unfinished" or not(normalize-space(translation)))]')
if ($missing.Count) { throw "$($missing.Count) Chinese translations remain incomplete" }
Write-Output "Simplified Chinese catalog complete: $($check.SelectNodes('//message').Count) entries checked."
