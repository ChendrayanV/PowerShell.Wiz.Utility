function Get-PSWizConfigurationFinding {
    <#
    .SYNOPSIS
        Retrieves configuration findings from the Wiz platform based on specified status and source.

    .DESCRIPTION
        The Get-PSWizConfigurationFinding function fetches configuration findings from the Wiz platform's API.
        It filters findings based on their status and source, such as 'OPEN', 'IN_PROGRESS', 'RESOLVED', 'REJECTED'
        for status, and 'WIZ_CSPM', 'ASC', 'AWSInspector' for source.

    .PARAMETER Status
        Specifies the status of the configuration findings to retrieve.
        Valid values: 'OPEN', 'IN_PROGRESS', 'RESOLVED', 'REJECTED'
        This parameter is mandatory.

    .PARAMETER Source
        Specifies the source of the configuration findings to retrieve.
        Valid values: 'WIZ_CSPM', 'ASC', 'AWSInspector'
        This parameter is mandatory.

    .EXAMPLE
        Get-PSWizConfigurationFinding -Status 'OPEN' -Source 'WIZ_CSPM'
        This example retrieves all configuration findings that are open and sourced from WIZ_CSPM.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of configuration findings based on the specified status and source.

    .NOTES
        The function constructs a GraphQL query from a local file named getConfigurationFinding.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('OPEN', 'IN_PROGRESS', 'RESOLVED', 'REJECTED')]
        $Status,

        [Parameter(Mandatory)]
        [ValidateSet('WIZ_CSPM', 'ASC', 'AWSInspector')]
        $Source
    )
    
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "getConfigurationFinding"
        query         = $(Get-Content -Path "$($queryPath)\graphql\getConfigurationFinding.graphql"-Raw)
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
            query         = $(Get-Content -Path "$($queryPath)\graphql\getConfigurationFinding.graphql"-Raw)
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