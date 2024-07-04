function Get-PSWizConnector {
    <#
    .SYNOPSIS
        Retrieves connector information from the Wiz platform based on their enabled state.

    .DESCRIPTION
        The Get-PSWizConnector function fetches connector information from the Wiz platform's API.
        It filters the connectors based on whether they are enabled or not, as specified by the user.

    .PARAMETER Enabled
        Specifies whether to retrieve enabled or disabled connectors.
        This parameter is mandatory.
        Valid values: $true, $false

    .EXAMPLE
        Get-PSWizConnector -Enabled $true
        This example retrieves all enabled connectors.

    .EXAMPLE
        Get-PSWizConnector -Enabled $false
        This example retrieves all disabled connectors.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of connectors based on the specified enabled state.

    .NOTES
        The function constructs a GraphQL query from a local file named getConnector.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [bool]
        $Enabled
    )
    
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "getConnector"
        query         = $(Get-Content -Path "$($queryPath)\graphql\getConnector.graphql" -Raw)
        variables     = @{
            enabled   = $Enabled
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        
        $Query = [PSCustomObject]@{
            operationName = "getConnector"
            query         = $(Get-Content -Path "$($queryPath)\graphql\getConnector.graphql" -Raw)
            variables     = @{
                enabled   = $Enabled
                endCursor = $response.data.connectors.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.connectors.nodes

        if ($response.data.connectors.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
}