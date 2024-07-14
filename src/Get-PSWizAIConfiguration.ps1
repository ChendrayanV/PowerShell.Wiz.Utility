function Get-PSWizAIConfiguration {
    <#
    .SYNOPSIS
        Retrieves the AI configuration settings from the Wiz API.

    .DESCRIPTION
        The Get-PSWizAIConfiguration function fetches AI configuration settings from the Wiz API using a GraphQL query.
        The function constructs the query from a file located in the same directory as the script and sends a POST request to the Wiz API endpoint.
        The function requires the API endpoint and access token to be stored in script scope variables.

    .PARAMETER None
        This function does not accept any parameters.

    .EXAMPLE
        Get-PSWizAIConfiguration
        This example demonstrates how to call the function to retrieve AI configuration settings from the Wiz API. 
        The output will be the AI settings if the request is successful.

    .OUTPUTS
        PSCustomObject
            The function outputs the AI configuration settings retrieved from the Wiz API.
    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "getAIConfiguration"
        query         = $(Get-Content -Path "$($queryPath)\graphql\getAIConfiguration.graphql"-Raw)
        
    } | ConvertTo-Json -Compress

    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    
    if ($response.errors) {
        $response.errors
    }

    else {
        $response.data.aiSettings
    }

}