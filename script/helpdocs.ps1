Import-Module .\PowerShell.Wiz.Utility.psd1 -Force -Verbose
# $OutputFolder = "docs"
# $parameters = @{
#     Module                = "PowerShell.Wiz.Utility"
#     OutputFolder          = $OutputFolder
#     AlphabeticParamsOrder = $true
#     WithModulePage        = $true
#     ExcludeDontShow       = $true
#     Encoding              = [System.Text.Encoding]::UTF8
# }
# New-MarkdownHelp @parameters

# New-MarkdownAboutHelp -OutputFolder $OutputFolder -AboutName "PowerShell.Wiz.Utility"

$parameters = @{
    Path                  = "docs"
    RefreshModulePage     = $true
    AlphabeticParamsOrder = $true
    UpdateInputOutput     = $true
    ExcludeDontShow       = $true
    Encoding              = [System.Text.Encoding]::UTF8
}
Update-MarkdownHelpModule @parameters