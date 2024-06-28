function Get-PSWizConfigurationFinding {
    <#
    .SYNOPSIS
        Retrieves configuration findings from a specified source with a given status.

    .DESCRIPTION
        The Get-PSWizConfigurationFinding cmdlet queries the Wiz API to retrieve configuration findings based on the specified status and source. The findings are retrieved using a GraphQL query and are returned as a collection.

    .PARAMETER Status
        Specifies the status of the configuration findings to retrieve. Valid values are:
            - OPEN
            - IN_PROGRESS
            - RESOLVED
            - REJECTED

    .PARAMETER Source
        Specifies the source of the configuration findings. Valid values are:
            - WIZ_CSPM
            - ASC
            - AWSInspector

    .EXAMPLE
        Get-PSWizConfigurationFinding -Status OPEN -Source WIZ_CSPM
        This command retrieves all configuration findings with the status 'OPEN' from the source 'WIZ_CSPM'.

    .EXAMPLE
        Get-PSWizConfigurationFinding -Status RESOLVED -Source AWSInspector
        This command retrieves all configuration findings with the status 'RESOLVED' from the source 'AWSInspector'.

    .OUTPUTS
        System.Object
        Returns a collection of configuration findings.

    .NOTES
        Author : Chendrayan Venkatesan (Chen V)
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
    
    $Query = [PSCustomObject]@{
        operationName = "getConfigurationFinding"
        query         = $(Get-Content .\graphql\getConfigurationFinding.graphql -Raw)
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
            query         = $(Get-Content .\graphql\getConfigurationFinding.graphql -Raw)
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