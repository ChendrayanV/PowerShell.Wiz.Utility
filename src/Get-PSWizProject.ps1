function Get-PSWizProject {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Provide a business impact, low, medium or high")]
        [ValidateSet('LBI', 'MBI', 'HBI')]
        $BusinessImpact
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getProject"
        query         = $(Get-Content .\graphql\getProject.graphql -Raw)
        variables     = @{
            impact    = $BusinessImpact
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getProject"
            query         = $(Get-Content .\graphql\getProject.graphql -Raw)
            variables     = @{
                impact    = $BusinessImpact
                endCursor = $response.data.projects.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.projects.nodes

        if ($response.data.projects.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection | . {
        process {
            [PSCustomObject]@{
                Id                = $($_.id)
                Name              = $($_.name)
                ProjectOwnerName  = $($_.projectOwners.name)
                ProjectOwnerEmail = $($_.projectOwners.email)
            }
        }
    }
    
}