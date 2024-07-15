function Invoke-PSWizAskAIRuleMatcher {
    <#
    .SYNOPSIS
    Invokes the Wiz.io AI Rule Matcher to match a rule with provided data.

    .DESCRIPTION
    The `Invoke-PSWizAskAIRuleMatcher` function sends a GraphQL query to the Wiz.io API to match a given rule with specific native type and example resource provider data. The function processes the response and returns the AI rule match results or errors if any.

    .PARAMETER RuleTitle
    Specifies the title of the rule to be matched.

    .PARAMETER NativeType
    Specifies the native type of the resource for which the rule is to be matched.

    .PARAMETER TFJson
    Specifies the example resource provider data in JSON format.

    .EXAMPLE
    PS C:\> $ruleTitle = "Example Rule"
    PS C:\> $nativeType = "ExampleType"
    PS C:\> $tfJson = '{"exampleKey": "exampleValue"}'
    PS C:\> Invoke-PSWizAskAIRuleMatcher -RuleTitle $ruleTitle -NativeType $nativeType -TFJson $tfJson

    This example matches the specified rule with the provided native type and example resource provider data, returning the AI rule match results.

    .NOTES
    The function requires a GraphQL query file named `askAIRuleMatcher.graphql` located in a subdirectory named `graphql` relative to the script's path. The script variables `$Script:Data_Center` and `$Script:Access_Token` must be set with the appropriate Wiz.io API data center and access token, respectively.

    .REQUIRES
    - PowerShell 5.1 or later
    - Invoke-RestMethod cmdlet
    - The GraphQL query file `askAIRuleMatcher.graphql` must be present in the `graphql` directory relative to the script's location.

    #>

    [CmdletBinding()]
    param (
        $RuleTitle,

        $NativeType,

        $TFJson
    )
    
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "askAIRuleMatcher"
        query         = $(Get-Content -Path "$($queryPath)\graphql\askAIRuleMatcher.graphql" -Raw)
        variables     = @{
            ruleTitle                   = $RuleTitle
            nativeType                  = $NativeType
            exampleResourceProviderData = $($TFJson | ConvertFrom-Json -AsHashtable)
        }
    } | ConvertTo-Json -Compress -Depth 9
    
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    
    if ($response.errors) {
        $response.errors
    }

    else {
        $response.data.aiRuleMatcher
    }
}