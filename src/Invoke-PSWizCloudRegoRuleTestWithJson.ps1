function Invoke-PSWizCloudRegoRuleTestWithJson {
    <#
    .SYNOPSIS
        Invokes a PSWiz Cloud Rego rule test using the provided JSON configuration.

    .DESCRIPTION
        The Invoke-PSWizCloudRegoRuleTestWithJson function sends a GraphQL query to the PSWiz API to run a Cloud Rego rule test.
        It requires the Rego rule and the Terraform JSON configuration as input parameters. The function constructs the query using a template file and sends it to the PSWiz API endpoint.
        The JSON configuration is converted from JSON to a hashtable before being sent in the query.

    .PARAMETER RegoRule
        The Rego rule to be tested. This parameter is mandatory.

    .PARAMETER TFJson
        The Terraform JSON configuration to be tested against the Rego rule. This parameter is mandatory.

    .EXAMPLE
        PS C:\> $regoRule = "my-rego-rule"
        PS C:\> $tfJson = Get-Content -Path "C:\path\to\tf.json" -Raw
        PS C:\> Invoke-PSWizCloudRegoRuleTestWithJson -RegoRule $regoRule -TFJson $tfJson

        This command invokes the PSWiz Cloud Rego rule test using the specified Rego rule and Terraform JSON configuration.

    .EXAMPLE
        PS C:\> $regoRule = "another-rego-rule"
        PS C:\> $tfJson = '{"resource": {"aws_instance": {"example": {"ami": "ami-123456", "instance_type": "t2.micro"}}}}'
        PS C:\> Invoke-PSWizCloudRegoRuleTestWithJson -RegoRule $regoRule -TFJson $tfJson

        This command invokes the PSWiz Cloud Rego rule test using the specified Rego rule and an inline Terraform JSON configuration.

    .EXAMPLE
        PS C:\> Invoke-PSWizCloudRegoRuleTestWithJson -RegoRule $(Get-Content .\data\test.rego -Raw) -TFJson $(Get-Content .\data\plan.json -Raw) 

        This command invokes the PSWiz Cloud Rego rule test using the specified Rego rule and an inline Terraform JSON configuration.

    .NOTES
        The function requires a GraphQL query template file named 'invokeCloudRegoRuleTest.graphql' located in a 'graphql' subfolder of the script's directory.
        It also requires that the script-level variables $Script:Data_Center and $Script:Access_Token be set with the appropriate values for the API endpoint and authentication.
        The JSON configuration is converted to a hashtable to ensure it is processed correctly by the GraphQL query.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $RegoRule,

        [Parameter(Mandatory)]
        $TFJson
    )
    
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "runCloudRegoRuleTestWithJson"
        query         = $(Get-Content -Path "$($queryPath)\graphql\invokeCloudRegoRuleTest.graphql" -Raw)
        variables     = @{
            rule = $RegoRule
            json = $($TFJson | ConvertFrom-Json -AsHashtable)
        }
    } | ConvertTo-Json -Compress -Depth 9
    
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    
    if ($response.errors) {
        $response.errors
    }

    else {
        $response.data.cloudConfigurationRuleJsonTest
    }
}