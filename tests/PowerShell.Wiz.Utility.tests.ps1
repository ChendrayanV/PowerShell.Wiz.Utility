param (
    $ClientID,

    $ClientSecret
)

Import-Module "$PSScriptRoot\..\PowerShell.Wiz.Utility.psd1" -Verbose -Force


Describe "PowerShell.Wiz.Utilty" {
    
    It "Wiz Authentication" {
        Get-PSWizAuthenticationToken -ClientID $($ClientID) -ClientSecret $($ClientSecret) | Should -BeNullOrEmpty
    }
}
