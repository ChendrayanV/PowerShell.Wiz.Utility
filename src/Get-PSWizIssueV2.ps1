function Get-PSWizIssueV2 {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Project GUID")]
        [string]
        $ProjectId
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getIssuesV2"
        query         = $(Get-Content .\graphql\getIssuesV2.graphql -Raw)
        variables     = @{
            projectId = @($ProjectId)
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getIssuesV2"
            query         = $(Get-Content .\graphql\getIssuesV2.graphql -Raw)
            variables     = @{
                projectId = @($ProjectId)
                endCursor = $response.data.issuesV2.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.issuesV2.nodes

        if ($response.data.issuesV2.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
    
}