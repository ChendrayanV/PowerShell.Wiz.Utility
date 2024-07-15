function Get-PSWizWorkLogScanTable {
    <#
    .SYNOPSIS
    Retrieves workload scan logs from Wiz.io API.

    .DESCRIPTION
    The `Get-PSWizWorkLogScanTable` function queries the Wiz.io API to retrieve workload scan logs. The function makes use of GraphQL queries and handles pagination automatically to collect all available logs.

    .PARAMETER None
    This function does not take any parameters.

    .EXAMPLE
    PS C:\> Get-PSWizWorkLogScanTable

    This example retrieves all workload scan logs and returns them as a collection of objects.

    .NOTES
    The function relies on a GraphQL query file named `getWorkloadScanLogTable.graphql` located in a subdirectory named `graphql` relative to the script's path. It also requires that the script variables `$Script:Data_Center` and `$Script:Access_Token` are set with the appropriate Wiz.io API data center and access token, respectively.
        - PowerShell 5.1 or later
        - Invoke-RestMethod cmdlet
        - The GraphQL query file `getWorkloadScanLogTable.graphql` must be present in the `graphql` directory relative to the script's location.

    #>

    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "getWorkloadScanLogTable"
        query         = $(Get-Content "$($queryPath)\graphql\getWorkloadScanLogTable.graphql" -Raw)
        variables     = @{
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()
    
    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        
        $Query = [PSCustomObject]@{
            operationName = "getWorkloadScanLogTable"
            query         = $(Get-Content "$($queryPath)\graphql\getWorkloadScanLogTable.graphql" -Raw)
            variables     = @{
                endCursor = $response.data.resourceScanResults.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        
        $Collection += $response.data.resourceScanResults.nodes
        
        if ($response.data.resourceScanResults.pageInfo.hasNextPage -eq $false) {
            break
        }
    }
    
    $Collection
    
}