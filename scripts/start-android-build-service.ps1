$ErrorActionPreference = 'Stop'
# Only start the existing Docker build service. No OS feature changes or reboots.
Start-Service -Name com.docker.service
Get-Service -Name com.docker.service | Select-Object Name,Status
