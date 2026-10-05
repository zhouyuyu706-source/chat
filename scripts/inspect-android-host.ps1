$ErrorActionPreference='Stop'
$features = @('Microsoft-Windows-Subsystem-Linux','VirtualMachinePlatform','Microsoft-Hyper-V-All') | ForEach-Object {
    Get-WindowsOptionalFeature -Online -FeatureName $_ | Select-Object FeatureName,State
}
$boot = & bcdedit.exe /enum '{current}'
@{ Features=$features; Boot=$boot } | ConvertTo-Json -Depth 4 | Out-File 'D:\Liaodanwang\android-host-diagnostic.json' -Encoding utf8
