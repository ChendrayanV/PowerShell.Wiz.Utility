param (
    $ClientID,

    $ClientSecret
)

Import-Module "$PSScriptRoot\..\PowerShell.Wiz.Utility.psd1" -Force


Describe "PowerShell.Wiz.Utilty" {
    
    Context 'Authenitcation' {
        It "Wiz Authentication" {
            Get-PSWizAuthenticationToken -ClientID $($ClientID) -ClientSecret $($ClientSecret) | Should -BeNullOrEmpty
        }
    }

    Context 'Retrieve Wiz Project' {
        It "List Wiz Project - All" {
            Get-PSWizProject | Should -BeOfType [System.Management.Automation.PSCustomObject]
        }
    }
}
