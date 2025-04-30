# Force-enable Real-Time Protection
Set-MpPreference -DisableRealtimeMonitoring $false
Start-Service -Name "WinDefend" -ErrorAction SilentlyContinue

# Verify
$defenderStatus = Get-MpComputerStatus | Select-Object -ExpandProperty RealTimeProtectionEnabled
if ($defenderStatus -eq $true) {
    Write-Output "Remediation Successful: Defender Real-Time Protection enabled."
    exit 0
} else {
    Write-Output "Remediation Failed: Defender still disabled."
    exit 1
}