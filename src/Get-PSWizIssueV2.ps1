function Get-PSWizIssueV2 {
    <#
    .SYNOPSIS
        Retrieves issues from the Wiz platform for a specified project.

    .DESCRIPTION
        The Get-PSWizIssueV2 function fetches issues from the Wiz platform's API for a specified project.
        It retrieves all issues associated with the provided project ID.

    .PARAMETER ProjectId
        Specifies the project GUID for which to retrieve issues.
        This parameter is optional.
        HelpMessage: Project GUID

    .EXAMPLE
        Get-PSWizIssueV2 -ProjectId "project123"
        This example retrieves all issues for the project with GUID "project123".

    .OUTPUTS
        PSCustomObject
            The function returns a collection of issues associated with the specified project.

    .NOTES
        The function constructs a GraphQL query from a local file named getIssuesV2.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Project GUID")]
        [string]
        $ProjectId
    )
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)
    $Query = [PSCustomObject]@{
        operationName = "getIssuesV2"
        query         = $(Get-Content -Path "$($queryPath)\graphql\getIssuesV2.graphql" -Raw)
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
            query         = $(Get-Content -Path "$($queryPath)\graphql\getIssuesV2.graphql" -Raw)
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