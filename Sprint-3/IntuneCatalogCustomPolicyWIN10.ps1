 Configuration DeployIntuneChromePolicy {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ApplicationId,
        
        [Parameter(Mandatory=$true)]
        [string]$TenantId,
        
        [Parameter(Mandatory=$true)]
        [string]$CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft.Graph.DeviceManagement

    IntuneSettingCatalogCustomPolicyWindows10 "IntuneSettingCatalogCustomPolicyWindows10-BI_DCP_DEV-WIN-Chrome Settings no id" {
        Assignments           = @(
            MSFT_DeviceManagementConfigurationPolicyAssignments{
                deviceAndAppManagementAssignmentFilterType = "none"
                dataType = "#microsoft.graph.groupAssignmentTarget"
                groupId = "077c5f5d-533a-4882-9638-cb40acd962a4"
            }
        )
        Description           = "This is a test setting 2 "
        Ensure                = "Present"
        Id                    = "7b4b8bc0-c672-44b6-9d01-11d4cfa1b59d"
        Name                  = "BI_DCP_DEV-WIN-Chrome NAFNAF"
        Platforms             = "windows10"
        Settings              = @(
            MSFT_MicrosoftGraphdeviceManagementConfigurationSetting{
                SettingInstance = MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance{
                    choiceSettingValue = MSFT_MicrosoftGraphDeviceManagementConfigurationChoiceSettingValue{
                        Value = "device_vendor_msft_policy_config_chromeintunev1~policy~googlechrome~passwordmanager_passwordmanagerenabled_0"
                    }
                    SettingDefinitionId = "device_vendor_msft_policy_config_chromeintunev1~policy~googlechrome~passwordmanager_passwordmanagerenabled"
                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                }
            }
            MSFT_MicrosoftGraphdeviceManagementConfigurationSetting{
                SettingInstance = MSFT_MicrosoftGraphDeviceManagementConfigurationSettingInstance{
                    choiceSettingValue = MSFT_MicrosoftGraphDeviceManagementConfigurationChoiceSettingValue{
                        Value = "user_vendor_msft_policy_config_chromeintunev1~policy~googlechrome~passwordmanager_passwordmanagerenabled_0"
                    }
                    SettingDefinitionId = "user_vendor_msft_policy_config_chromeintunev1~policy~googlechrome~passwordmanager_passwordmanagerenabled"
                    odataType = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                }
            }
        )
        Technologies          = "mdm"
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        CertificateThumbprint = $CertificateThumbprint
    }
} 