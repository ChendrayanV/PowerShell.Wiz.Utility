function Get-PSWizCloudConfigurationRule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ParameterSetName='Enabled')]
        [bool]
        $Enabled
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getCloudConfigurationRule"
        query         = $(Get-Content .\graphql\getCloudConfigurationRule.graphql -Raw)
        variables     = @{
            enabled   = $Enabled
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getCloudConfigurationRule"
            query         = $(Get-Content .\graphql\getCloudConfigurationRule.graphql -Raw)
            variables     = @{
                enabled   = $Enabled
                endCursor = $response.data.cloudConfigurationRules.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.cloudConfigurationRules.nodes

        if ($response.data.cloudConfigurationRules.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
}