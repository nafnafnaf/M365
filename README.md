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


## Before using Connect ps1 script do the following:
Modify Connect-M365Services accordingly for username etc.
Add -Credential parameter for non-interactive use

 Basic connection (all services)
 
```
.\Connect-M365Services.ps1
```
 Skip Teams connection
```.\Connect-M365Services.ps1 -SkipTeams
```
 Specify tenant ID (for multi-tenant environments)
```.\Connect-M365Services.ps1 -TenantId "yourdomain.onmicrosoft.com"
```
