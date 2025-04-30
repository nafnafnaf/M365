# Check if Windows Defender Real-Time Protection is enabled
$defenderStatus = Get-MpComputerStatus | Select-Object -ExpandProperty RealTimeProtectionEnabled

if ($defenderStatus -eq $true) {
    Write-Output "Compliant: Defender Real-Time Protection is enabled."
    exit 0  # Exit code 0 = No remediation needed
} else {
    Write-Output "Non-Compliant: Defender Real-Time Protection is disabled."
    exit 1  # Exit code 1 = Remediation required
}