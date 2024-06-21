function Get-PSWizConnectorType {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Provide Connecty ID (aws, azure, ecr)")]
        $Id
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getConnectorType"
        query         = $(Get-Content .\graphql\getConnectorType.graphql -Raw)
        
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getConnectorType"
            query         = $(Get-Content .\graphql\getConnectorType.graphql -Raw)
            
        } | ConvertTo-Json -Compress
        $Collection += $response.data.connectorTypes.nodes

        if ($response.data.connectorTypes.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
    
}