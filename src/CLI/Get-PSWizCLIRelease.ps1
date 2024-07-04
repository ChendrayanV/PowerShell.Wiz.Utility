function Get-PSWizCLIRelease {
    <#
    .SYNOPSIS
        Retrieves CLI release information from the Wiz platform based on the specified platform.

    .DESCRIPTION
        The Get-PSWizCLIRelease function fetches CLI release information from the Wiz platform's API.
        It allows filtering of CLI releases based on the specified platform, such as WINDOWS, LINUX, DARWIN, or DOCKER_LINUX.

    .PARAMETER Platform
        Specifies the platform for which to retrieve CLI release information.
        Valid values: 'WINDOWS', 'LINUX', 'DARWIN', 'DOCKER_LINUX'
        This parameter is optional and helps to filter the results based on the platform.

    .EXAMPLE
        Get-PSWizCLIRelease -Platform "WINDOWS"
        This example retrieves all CLI releases for the Windows platform.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of CLI release information based on the specified platform.

    .NOTES
        The function constructs a GraphQL query from a local file named getCLIRelease.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Provide a business impact, low, medium or high")]
        [ValidateSet('WINDOWS', 'LINUX', 'DARWIN', 'DOCKER_LINUX')]
        $Platform
    )

    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)
    
    $Query = [PSCustomObject]@{
        operationName = "getCLIRelease"
        query         = $(Get-Content -Path "$($queryPath)\graphql\getCLIRelease.graphql" -Raw)
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
            query         = $(Get-Content -Path "$($queryPath)\graphql\getCLIRelease.graphql" -Raw)
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