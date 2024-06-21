@{
    Verb                    = 'Get'
    Noun                    = 'WizVersion'
    OriginalName            = '.\bin\win\wizcli.exe'
    OriginalCommandElements = @("version")
    Description             = "a cmdlet to retrieve the current version on the Wiz CLI"
    Platform                = @('Windows')
    OutputHandlers = @{
            ParameterSetName = "Default"
            Handler          = { $true }
            HandlerType      = "ByPass"
            StreamOutput     = $false
        }
    
    SupportsShouldProcess = $true
    SupportsTransactions = $true
    NoInvocation = $true
    Parameters = @()
    Examples = @()
}