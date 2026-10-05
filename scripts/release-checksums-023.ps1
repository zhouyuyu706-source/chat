$ErrorActionPreference='Stop'
$downloads=Join-Path $PSScriptRoot '../website/public/downloads'
$names=@('Zova-0.2.3-Windows-x64.msi','Zova-0.2.3-source-complete.tar.gz','RELEASE-0.2.3.md')
$lines=foreach($name in $names) {
    $hash=(Get-FileHash -LiteralPath (Join-Path $downloads $name) -Algorithm SHA256).Hash.ToLowerInvariant()
    "$hash  $name"
}
[IO.File]::WriteAllLines((Join-Path $downloads 'SHA256SUMS-0.2.3.txt'),$lines,[Text.UTF8Encoding]::new($false))
$lines
