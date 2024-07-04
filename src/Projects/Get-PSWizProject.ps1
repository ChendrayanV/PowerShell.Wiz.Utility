function Get-PSWizProject {
    <#
    .SYNOPSIS
        Retrieves project information from the Wiz platform based on business impact.

    .DESCRIPTION
        The Get-PSWizProject function fetches project information from the Wiz platform's API.
        It filters projects based on the specified business impact (LBI, MBI, HBI) and compiles the results into a collection.

    .PARAMETER BusinessImpact
        Specifies the business impact level to filter the projects.
        Valid values: 'LBI', 'MBI', 'HBI'
        HelpMessage: Provide a business impact, low, medium, or high.

    .EXAMPLE
        Get-PSWizProject -BusinessImpact "HBI"
        This example retrieves all projects with a high business impact (HBI).

    .OUTPUTS
        PSCustomObject
            The function returns a collection of projects with the specified business impact.
            Each object contains the project ID, name, project owner name, and project owner email.

    .NOTES
        The function constructs a GraphQL query from a local file named getProject.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

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