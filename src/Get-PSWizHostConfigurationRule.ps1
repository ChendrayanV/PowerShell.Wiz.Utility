function Get-PSWizHostConfigurationRule {
    <#
    .SYNOPSIS
    Retrieves host configuration rules from the Wiz API using GraphQL queries.

    .DESCRIPTION
    The `Get-PSWizHostConfigurationRule` function is designed to fetch host configuration rules from the Wiz API. It uses GraphQL queries to retrieve the data, handling pagination to ensure all relevant data is collected.

    .PARAMETER None
    This function does not take any parameters.

    .EXAMPLE
    PS C:\> Get-PSWizHostConfigurationRule

    This example runs the function and retrieves all host configuration rules from the Wiz API.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    Array of PSCustomObject
    The function returns an array of PSCustomObject, each representing a host configuration rule retrieved from the Wiz API.

    .NOTES
    - This function requires the script to have access to the Wiz API endpoint and appropriate authorization tokens.
    - The function handles pagination to ensure all data is retrieved.
    - The GraphQL query is expected to be located in the 'graphql' subdirectory relative to the script's location.

    .COMPONENT
    Wiz API, GraphQL

    .FUNCTIONALITY
    Host Configuration Rules Retrieval

    #>

    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)
    
    $Query = [PSCustomObject]@{
        operationName = "gethostConfigurationRule"
        query         = $(Get-Content -Path "$($queryPath)\graphql\getHostConfigurationRule.graphql" -Raw)
        variables     = @{
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "gethostConfigurationRule"
            query         = $(Get-Content -Path "$($queryPath)\graphql\getHostConfigurationRule.graphql" -Raw)
            variables     = @{
                endCursor = $response.data.hostConfigurationRules.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.hostConfigurationRules.nodes

        if ($response.data.hostConfigurationRules.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
}