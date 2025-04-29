Modify Connect-M365Services accordingly for username etc.

Add -Credential parameter for non-interactive use

# Basic connection (all services)
.\Connect-M365Services.ps1

# Skip Teams connection
.\Connect-M365Services.ps1 -SkipTeams

# Specify tenant ID (for multi-tenant environments)
.\Connect-M365Services.ps1 -TenantId "yourdomain.onmicrosoft.com"
