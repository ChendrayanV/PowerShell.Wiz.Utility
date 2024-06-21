@{
    Verb                    = 'Connect'
    Noun                    = 'WizTenant'
    OriginalName            = '.\bin\win\wizcli.exe'
    OriginalCommandElements = @("auth")
    Description             = "a cmdlet to retrieve the current version on the Wiz CLI"
    Platform                = @(
        'Windows'
    )
    Parameters  = @{
        ParameterType                   = "string"
        Name                            = "ClientID"
        OriginalName                    = '--id'
        Description                     = ""
        ValueFromPipeline               = $false
        ValueFromPipelineByPropertyName = $true
        AdditionalParameterAttributes   = ''
        ParameterSetName                = "Default"
    },
    @{
        ParameterType                   = "string"
        Name                            = "Secret"
        OriginalName                    = '--secret'
        Description                     = ""
        ValueFromPipeline               = $false
        ValueFromPipelineByPropertyName = $true
        AdditionalParameterAttributes   = ''
        ParameterSetName                = "Default"
     }
    OutputHandlers          = @{
        ParameterSetName = "Default"
        Handler          = {$args}
        HandlerType      = "Bypass"
        StreamOutput     = $false
    }
}