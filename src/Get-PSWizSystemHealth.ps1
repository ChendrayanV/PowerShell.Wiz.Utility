function Get-PSWizSystemHealth {
    <#
    .SYNOPSIS
        Retrieves system health issues from the Wiz platform.

    .DESCRIPTION
        The Get-PSWizSystemHealth function fetches system health issues from the Wiz platform's API.
        It retrieves all system health issues and compiles them into a collection with specific details.

    .EXAMPLE
        Get-PSWizSystemHealth
        This example retrieves all system health issues from the Wiz platform.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of system health issues with details including
            ID, name, deployment ID, deployment name, deployment type, severity, and the last seen timestamp.

    .NOTES
        The function constructs a GraphQL query from a local file named getSystemHealthIssue.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "getSystemHealthIssue"
        query         = $(Get-Content "$($queryPath)\graphql\getSystemHealthIssue.graphql" -Raw)
        variables     = @{
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getSystemHealthIssue"
            query         = $(Get-Content "$($queryPath)\graphql\getSystemHealthIssue.graphql" -Raw)
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
                Status         = $($_.Status)
                DeploymentId   = $($_.deployment.id)
                DeploymentName = $($_.deployment.name)
                DeploymentType = $($_.deployment.type)
                Severity       = $($_.severity)
                LastSeenAt     = $($_.lastSeenAt)
            }
        }
    }
    
}