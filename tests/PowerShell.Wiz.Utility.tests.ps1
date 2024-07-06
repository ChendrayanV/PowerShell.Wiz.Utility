param (
    $Param1
)

Import-Module "$PSScriptRoot\..\PowerShell.Wiz.Utility.psd1" -Verbose -Force


Describe "PowerShell.Wiz.Utilty" {
    
    It "dummt test" {
        $Param1 | Should -BeExactly 1
    }
}
