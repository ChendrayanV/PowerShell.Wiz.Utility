param (
    $Wiz_CLIENT_ID,

    $Wiz_CLIENT_SECRET
)

Import-Module .\PowerShell.Wiz.Utility.psm1

Describe "PowerShell.Wiz.Utilty" {
    
    It "PSWizAuthenticationToken should return null" {
        Get-PSWizAuthenticationToken -ClientID $Wiz_CLIENT_ID -ClientSecret $Wiz_CLIENT_SECRET | Should -BeExactly $null
    }

    It "PSWizCLIRelease should be of type pscustomobject" {
        Get-PSWizCLIRelease | Should -BeOfType [System.Management.Automation.PSCustomObject]
    }

    It "PSWizCloudConfigurationRule should be of type pscustomobject" {
        Get-PSWizCloudConfigurationRule -Enabled $true | Should -BeOfType [System.Management.Automation.PSCustomObject]
    }
    
    It "graphql folder should have 8 files" {
        (Get-ChildItem -Path .\graphql | Measure-Object).Count | Should -BeExactly 10   
    }
}