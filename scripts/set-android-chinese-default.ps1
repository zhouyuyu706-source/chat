$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$res=Join-Path $root 'client-android/ring-android/app/src/main/res'
$basePath=Join-Path $res 'values/strings.xml'
$base=[xml](Get-Content -LiteralPath $basePath -Raw)
$chinese=[xml](Get-Content -LiteralPath (Join-Path $res 'values-zh-rCN/strings.xml') -Raw)
$translations=@{}
foreach ($entry in $chinese.resources.ChildNodes) {
  if ($entry.NodeType -eq 'Element') { $translations[$entry.GetAttribute('name')]=$entry }
}
$count=0
foreach ($entry in @($base.resources.ChildNodes)) {
  if ($entry.NodeType -ne 'Element' -or $entry.GetAttribute('translatable') -eq 'false') { continue }
  $key=$entry.GetAttribute('name')
  if (!$translations.ContainsKey($key)) { throw "Missing Chinese resource: $key" }
  $replacement=$base.ImportNode($translations[$key],$true)
  [void]$base.resources.ReplaceChild($replacement,$entry)
  $count++
}
$settings=[System.Xml.XmlWriterSettings]::new()
$settings.Encoding=[System.Text.UTF8Encoding]::new($false)
$settings.Indent=$true
$writer=[System.Xml.XmlWriter]::Create($basePath,$settings)
try { $base.Save($writer) } finally { $writer.Dispose() }
Write-Output "Chinese default strings applied: $count"
