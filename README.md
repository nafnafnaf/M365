# Microsoft 365 Automation Toolkit

![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Azure](https://img.shields.io/badge/Microsoft-365-0078D4.svg)

A collection of PowerShell scripts for automating Microsoft 365 administration tasks, including user management, reporting, and security configurations.

## 📦 Included Modules

| Module | Description |
|--------|-------------|
| **Connect-M365Services.ps1** | Unified connection script for Exchange Online, SharePoint, Teams, and Azure AD |
| **UserManagement** | Bulk user creation/licensing, group management |
| **Security** | Conditional Access policies, MFA reports |
| **Reports** | License usage, mailbox statistics, inactive users |
| **SharePoint** | Site provisioning, permission management |

## 🚀 Quick Start

### Prerequisites
- PowerShell 5.1+ (7.x recommended)
- Global Admin or appropriate M365 admin rights
- Installed modules:
  ```powershell
  Install-Module -Name ExchangeOnlineManagement,Microsoft.Online.SharePoint.PowerShell,MicrosoftTeams,AzureAD -Force -AllowClobber

🖥️ VS Code Configuration
Recommended Extensions
PowerShell

Azure Account

Microsoft Graph Tools

settings.json

```json

{
  "powershell.powerShellExePath": "C:\\Program Files\\PowerShell\\7\\pwsh.exe",
  "azure.tenant": "yourtenant.onmicrosoft.com",
  "powershell.codeFormatting.preset": "OTBS",
  "files.autoSave": "afterDelay"
}
```
🔐 Authentication Methods
Interactive Login (MFA Supported)
```powershel
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"
Connect-AzureAD
```
Non-Interactive with Credentials
```powershell
$Credential = Get-Credential
.\Connect-M365Services.ps1 -Credential $Credential -TenantId "contoso.onmicrosoft.com"
```
Certificate-Based Auth
```powershell
Connect-MgGraph -ClientId "app-id" -TenantId "tenant-id" `
  -CertificateThumbprint "cert-thumbprint"
```
📋 Script Usage
Before First Use Modify Connect-M365Services accordingly for username etc.
Add -Credential parameter for non-interactive use
```powershell
# Modify these in Connect-M365Services.ps1
$DefaultAdmin = "admin@contoso.onmicrosoft.com"
$DefaultTenant = "contoso.onmicrosoft.com"```
```

Basic connection (all services)
 
```
.\Connect-M365Services.ps1
```
```
# Basic connection (all services)
.\Connect-M365Services.ps1
```

# With specific parameters
```
.\Connect-M365Services.ps1 -SkipTeams -Credential (Import-Clixml "./secure/cred.xml")
```
Skip Teams connection
```
.\Connect-M365Services.ps1 -SkipTeams
```
Specify tenant ID (for multi-tenant environments)
```
.\Connect-M365Services.ps1 -TenantId "yourdomain.onmicrosoft.com"
```
