function Get-PSWizConnector {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [bool]
        $Enabled
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getConnector"
        query         = $(Get-Content .\graphql\getConnector.graphql -Raw)
        variables     = @{
            enabled   = $Enabled
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        
        $Query = [PSCustomObject]@{
            operationName = "getConnector"
            query         = $(Get-Content .\graphql\getConnector.graphql -Raw)
            variables     = @{
                enabled   = $Enabled
                endCursor = $response.data.connectors.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.connectors.nodes

        if ($response.data.connectors.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
}