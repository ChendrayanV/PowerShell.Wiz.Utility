function Get-PSWizConfigurationFinding {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('OPEN', 'IN_PROGRESS', 'RESOLVED', 'REJECTED')]
        $Status,

        [Parameter(Mandatory)]
        [ValidateSet('WIZ_CSPM', 'ASC', 'AWSInspector')]
        $Source
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getConfigurationFinding"
        query         = $(Get-Content .\graphql\getConfigurationFinding.graphql -Raw)
        variables     = @{
            endCursor = $null
            status    = $Status
            source    = $Source
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getConfigurationFinding"
            query         = $(Get-Content .\graphql\getConfigurationFinding.graphql -Raw)
            variables     = @{
                endCursor = $response.data.configurationFindings.pageInfo.endCursor
                status    = $Status
                source    = $Source
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.configurationFindings.nodes

        if ($response.data.configurationFindings.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
}