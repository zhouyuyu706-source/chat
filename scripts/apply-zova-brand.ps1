param([string]$Root = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)
function Rewrite([string]$Path, [scriptblock]$Transform) {
    $old = [IO.File]::ReadAllText($Path)
    $new = & $Transform $old
    if ($old -cne $new) { [IO.File]::WriteAllText($Path, $new, $utf8) }
}
# Only user-facing string literals: retain C++/QML namespaces and protocol symbols.
Get-ChildItem "$Root/client-qt/src" -Recurse -File | Where-Object Extension -in '.qml','.cpp' | ForEach-Object {
    Rewrite $_.FullName { param($s)
        [regex]::Replace($s, '"(?:[^"\\]|\\.)*"', {
            param($m)
            ($m.Value -creplace '\bJami\b', 'Zova').Replace('\nJami ', '\nZova ')
        })
    }
}
# Keep translated source keys consistent with the rebranded user-facing strings.
Get-ChildItem "$Root/client-qt/translations" -Filter '*.ts' | ForEach-Object {
    Rewrite $_.FullName { param($s) $s -creplace '\bJami\b', 'Zova' }
}
Get-ChildItem "$Root/client-android/ring-android/app/src/main/res" -Recurse -Filter 'strings.xml' | ForEach-Object {
    Rewrite $_.FullName { param($s) $s -creplace '\bJami\b', 'Zova' }
}
Rewrite "$Root/client-qt/JamiInstaller/Config.wxi" { param($s)
    $s.Replace('Name="Jami', 'Name="Zova').Replace('Manufacturer="Savoir-Faire Linux"','Manufacturer="Zova"')
}
Rewrite "$Root/client-qt/JamiInstaller/Product.wxs" { param($s)
    $s.Replace('7c45b52b-0390-4fe8-947a-3f13e82dd346','81a74a1b-e6db-4bdf-873c-0be9d9064a42').Replace('Software\jami.net\','Software\Zova\')
}
# Internal protocol symbols are not display names.
Get-ChildItem "$Root/client-qt" -Filter '*.desktop*' | ForEach-Object {
    Rewrite $_.FullName { param($s) $s -replace '(?m)^Name=Jami', 'Name=Zova' }
}
Rewrite "$Root/client-ios/Ring/Ring/Info.plist" { param($s) $s.Replace('<string>Jami</string>', '<string>Zova</string>') }
Get-ChildItem "$Root/client-ios" -Recurse -Filter 'InfoPlist.strings' | ForEach-Object {
    Rewrite $_.FullName { param($s) $s -creplace '\bJami\b', 'Zova' }
}
Write-Output 'Zova text branding applied; licenses, namespaces and protocol identifiers retained.'
