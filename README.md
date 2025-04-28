InTune Compliance Policy and Scripts and remediation
28-04-2025 
Retrospective meeting - closing Sprint #1
Resuming knowledge of last 2 weeks for M365 team
•	1. Compliance Policies 
o	Purpose:
o	Common Compliance Policy Settings:
o	How Compliance Policies Work:
•	2. Scripts & Remediation 
o	Purpose:
•	Types of Scripts in Intune:
•	Common Use Cases for Scripts/Remediation:
•	How Remediation Scripts Work:
•	Summary 
o	Compliance Policies = "Must meet these rules to access company data."
o	Scripts & Remediation = "Automatically detect and fix problems."
•	Compliance Policy (Declarative Approach) 
o	defender-realtime-compliance.json
o	Deploying Policy via Graph API (CI/CD Pipeline)
•	3. Proactive Remediation (Self-Healing) 
o	Detection Script (detect-defender.ps1)
o	Remediation Script (enable-defender.ps1)
o	Deploying Scripts via Intune API
•	GitOps Workflow = Git as the single source of truth
•	Key DevOps Principles Applied 
o	Final Result
Intune compliance policies are divided into two areas:
Microsoft Intune is a cloud-based Endpoint Management solution that helps manage devices, apps, and policies. Two key components in Intune are Compliance Policies and Scripts.
1. Compliance Policies
Purpose:

Compliance Policies define the rules and settings that devices must meet to be considered "compliant" with organizational security standards. Non-compliant devices can be blocked from accessing corporate resources.
Key Concepts:
•	Device Compliance: Determines if a device meets security requirements (e.g., encryption, password complexity, OS version).
•	Actions for Non-Compliance: Automatically remediate or block access (e.g., send alerts, retire the device, or restrict access to email).
•	Conditional Access Integration: Ensures only compliant devices can access company data (e.g., Office 365, SharePoint).
Common Compliance Policy Settings:
Password Requirements (length, complexity)
Minimum/Maximum OS Version (e.g., Windows 11 22H2 or later)
Disk Encryption (BitLocker for Windows, FileVault for macOS)
Jailbroken/Rooted Detection (blocks compromised devices)
Antivirus & Firewall Status (e.g., Windows Defender must be enabled)
How Compliance Policies Work:
1.	Admin defines compliance rules in Intune.
2.	Devices check in and report their status.
3.	Intune marks devices as Compliant or Non-Compliant.
4.	Conditional Access enforces access controls based on compliance.
2. Scripts & Remediation
Purpose:
•	Scripts (including Proactive Remediations) allow IT admins (eg. M365 team) to detect and fix issues automatically on managed devices.
Types of Scripts in Intune:
•	PowerShell Scripts (Windows):
o	 Used for one-time deployments (e.g., install software, configure settings).
o	 Runs in system context (admin privileges).
•	 Shell Scripts (macOS/Linux):
o	 Similar to PowerShell but for Unix-based systems.
•	 Proactive Remediations:
o	Detect & Remediate Scripts:
	 Detection Script (checks for an issue).
	 Remediation Script (fixes it if detected).
•	 Runs automatically and periodically 
 Example: Fix missing registry keys, reapply security policies, clean temp files.
$folderPath = "C:\PmpcExitCodes"
$filePath = "$folderPath\exitcodes.txt"

if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory -Force
}

if (-not (Test-Path -Path $filePath)) {
    New-Item -Path $filePath -ItemType File -Force
    Add-Content -Path $filePath -Value "Creating $filePath"
}

$userProfiles = Get-WmiObject Win32_UserProfile | Where-Object { $_.Special -eq $false -and $_.LocalPath -match "C:\\Users\\" }

foreach ($profile in $userProfiles) {
    $userLocalAppData = "$($profile.LocalPath)\AppData\Local"
    $devolutionsFolder = "$userLocalAppData\Devolutions"
    $targetFilePath = "$devolutionsFolder\RemoteDesktopManager\RemoteDesktopManager.cfg"
    $exitCode = 0

    if (Test-Path -Path $devolutionsFolder) {
        if (Test-Path -Path $targetFilePath) {
            try {
                Rename-Item -Path $targetFilePath -NewName "RemoteDesktopManager_old.cfg" -ErrorAction Stop
                $message = "Success: Renamed file for user $($profile.LocalPath)."
            } catch {
                $exitCode = 1
                $message = "Error: Failed to rename file for user $($profile.LocalPath). Exception: $($_.Exception.Message)"
            }
        } else {
            $exitCode = 1
            $message = "Error: The file does not exist for user $($profile.LocalPath) at path: $targetFilePath."
        }
    } else {
        $exitCode = 1
        $message = "Error: The Devolutions directory does not exist for user $($profile.LocalPath)."
    }

    $exitCodeMessage = "Exit Code: $exitCode - $message"
    Add-Content -Path $filePath -Value $exitCodeMessage
    Write-Host $exitCodeMessage
}

exit 0

#1) rename and do not delete the .cfg file with db servers and passwords
#2) why does the script modifies the SYSTEM user and not the local users --> intune talks to the SYSTEM API so solution is to modify all users' settings 
 Common Use Cases for Scripts/Remediation:
> Deploy Custom Software Configurations
> Fix Misconfigured Registry Keys
> Remove Unapproved Software
> Ensure Security Baselines Are Applied
 How Remediation Scripts Work:
Detection Script runs first (checks if a problem exists).
 If issue found → triggers Remediation Script.
 If no issue → does nothing.
 Remediation Script executes the fix (e.g., reset a policy, install a patch).
 Results are logged in Intune for monitoring.
 Summary
Compliance Policies = "Must meet these rules to access company data."
Scripts & Remediation = "Automatically detect and fix problems."
 
 
Compliance Policy (Declarative Approach)
Intune natively uses declarative policies.
We define the policy in JSON format using tools like Bicep/Terraform/Pulumi (GitOps principles).
 
defender-realtime-compliance.json
{
  "@odata.type": "#microsoft.graph.windows10CompliancePolicy",
  "displayName": "Require Windows Defender Real-Time Protection",
  "description": "Devices must have Defender Real-Time Protection enabled.",
  "defenderEnabled": true,
  "scheduledActionsForRule": [
    {
      "ruleName": "PasswordRequired",
      "scheduledActionConfigurations": [
        {
          "actionType": "block",
          "gracePeriodHours": 0,
          "notificationTemplateId": "",
          "notificationMessageCCList": []
        }
      ]
    }
  ]
}
Deploying Policy via Graph API (CI/CD Pipeline)
# deploy-pipeline.yml (Azure DevOps/GitHub Actions)
steps:
- task: PowerShell@2
  inputs:
    targetType: 'inline'
    script: |
      # Authenticate to Microsoft Graph
      $token = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com").Token
      $headers = @{ Authorization = "Bearer $token" }

      # Deploy Compliance Policy
      $policy = Get-Content "./compliance-policies/defender-realtime-compliance.json" | ConvertFrom-Json
      Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies" `
                        -Method Post `
                        -Headers $headers `
                        -Body ($policy | ConvertTo-Json -Depth 5) `
                        -ContentType "application/json"
3. Proactive Remediation (Self-Healing)
Detection Script (detect-defender.ps1)
# Check if Windows Defender Real-Time Protection is enabled
$defenderStatus = Get-MpComputerStatus | Select-Object -ExpandProperty RealTimeProtectionEnabled

if ($defenderStatus -eq $true) {
    Write-Output "Compliant: Defender Real-Time Protection is enabled."
    exit 0  # Exit code 0 = No remediation needed
} else {
    Write-Output "Non-Compliant: Defender Real-Time Protection is disabled."
    exit 1  # Exit code 1 = Remediation required
}
Remediation Script (enable-defender.ps1)
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
Deploying Scripts via Intune API
- task: PowerShell@2
  inputs:
    targetType: 'inline'
    script: |
      $token = (Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com").Token
      $headers = @{ Authorization = "Bearer $token" }

      # Upload Detection Script
      $detectScript = Get-Content "./remediation-scripts/detect-defender.ps1" -Raw
      $body = @{
        displayName = "Detect Defender Real-Time Status"
        description = "Checks if Defender Real-Time Protection is enabled."
        scriptContent = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($detectScript))
        runAs32Bit = $false
        enforceSignatureCheck = $false
        runAsAccount = "system"
      }

      Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/deviceManagement/deviceHealthScripts" `
                        -Method Post `
                        -Headers $headers `
                        -Body ($body | ConvertTo-Json) `
                        -ContentType "application/json"

      # Upload Remediation Script (similar approach)
GitOps Workflow = Git as the single source of truth
1.	Commit Changes → PR triggers pipeline.
2.	Pipeline Validates & Deploys:
o	Uploads scripts to Intune.
o	Updates compliance policies via Graph API.
3.	Monitoring:
o	Intune reports compliance status.
o	Remediation logs stored in Azure Monitor.
Key DevOps Principles Applied
1.	Infrastructure as Code (IaC)
o	Policies & scripts stored in Git.
2.	CI/CD Automation
o	Pipeline deploys changes to Intune.
3.	Self-Healing (Remediation)
o	Fixes issues without manual intervention.
4.	Monitoring & Logging
o	Azure Monitor tracks compliance/remediation.
Final Result
•	Non-compliant devices are automatically fixed by remediation scripts.
•	Compliance status is enforced via Git-managed policies.
•	Full audit trail in Git history.
