function Get-PSWizCLIRelease {
    <#
    .SYNOPSIS
        Retrieves the latest CLI release information for the specified platform.

    .DESCRIPTION
        The Get-PSWizCLIRelease cmdlet sends a GraphQL query to the Wiz API to retrieve the latest CLI release information for a specified platform. The available platforms include WINDOWS, LINUX, DARWIN, and DOCKER_LINUX. The cmdlet uses a paging mechanism to ensure all release data is collected if multiple pages of results are returned.

    .PARAMETER Platform
        Specifies the platform for which to retrieve the CLI release information. Valid values are WINDOWS, LINUX, DARWIN, and DOCKER_LINUX.

    .EXAMPLE
        PS C:\> Get-PSWizCLIRelease -Platform WINDOWS
        This example retrieves the latest CLI release information for the Windows platform.

    .EXAMPLE
        PS C:\> Get-PSWizCLIRelease -Platform LINUX
        This example retrieves the latest CLI release information for the Linux platform.

    .NOTES
        This function requires an active access token stored in the global variable $Access_Token and the data center information stored in the global variable $Data_Center. The function reads a GraphQL query from a file named getCLIRelease.graphql located in the .\graphql\ directory.

    .LINK
        https://docs.wiz.io/cli-releases
    #>

    
    
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Provide a business impact, low, medium or high")]
        [ValidateSet('WINDOWS', 'LINUX', 'DARWIN', 'DOCKER_LINUX')]
        $Platform
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getCLIRelease"
        query         = $(Get-Content .\graphql\getCLIRelease.graphql -Raw)
        variables     = @{
            platform  = $Platform
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getCLIRelease"
            query         = $(Get-Content .\graphql\getCLIRelease.graphql -Raw)
            variables     = @{
                platform  = $Platform
                endCursor = $response.data.cliReleases.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.cliReleases.nodes

        if ($response.data.cliReleases.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
    
}