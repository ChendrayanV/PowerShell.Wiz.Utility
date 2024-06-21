function Get-PSWizSystemHealth {
    # [CmdletBinding()]
    # param (
    #     [Parameter(HelpMessage = "Provide a business impact, low, medium or high")]
    #     [ValidateSet('LBI', 'MBI', 'HBI')]
    #     $BusinessImpact
    # )
    
    $Query = [PSCustomObject]@{
        operationName = "getSystemHealthIssue"
        query         = $(Get-Content .\graphql\getSystemHealthIssue.graphql -Raw)
        variables     = @{
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getSystemHealthIssue"
            query         = $(Get-Content .\graphql\getSystemHealthIssue.graphql -Raw)
            variables     = @{
                endCursor = $response.data.systemHealthIssues.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.systemHealthIssues.nodes

        if ($response.data.systemHealthIssues.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection | . {
        process {
            [PSCustomObject]@{
                Id             = $($_.id)
                Name           = $($_.name)
                DeploymentId   = $($_.deployment.id)
                DeploymentName = $($_.deployment.name)
                DeploymentType = $($_.deployment.type)
                Severity       = $($_.severity)
                LastSeenAt     = $($_.lastSeenAt)
            }
        }
    }
    
}