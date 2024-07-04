function Get-PSWizCloudConfigurationRule {
    <#
    .SYNOPSIS
        Retrieves cloud configuration rules from the Wiz platform based on their enabled state.

    .DESCRIPTION
        The Get-PSWizCloudConfigurationRule function fetches cloud configuration rules from the Wiz platform's API.
        It filters the rules based on whether they are enabled or not, as specified by the user.

    .PARAMETER Enabled
        Specifies whether to retrieve enabled or disabled cloud configuration rules.
        This parameter is mandatory and part of the 'Enabled' parameter set.
        Valid values: $true, $false

    .EXAMPLE
        Get-PSWizCloudConfigurationRule -Enabled $true
        This example retrieves all enabled cloud configuration rules.

    .EXAMPLE
        Get-PSWizCloudConfigurationRule -Enabled $false
        This example retrieves all disabled cloud configuration rules.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of cloud configuration rules based on the specified enabled state.

    .NOTES
        The function constructs a GraphQL query from a local file named getCloudConfigurationRule.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ParameterSetName='Enabled')]
        [bool]
        $Enabled
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getCloudConfigurationRule"
        query         = $(Get-Content $PSScriptRoot\graphql\getCloudConfigurationRule.graphql -Raw)
        variables     = @{
            enabled   = $Enabled
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getCloudConfigurationRule"
            query         = $(Get-Content .\graphql\getCloudConfigurationRule.graphql -Raw)
            variables     = @{
                enabled   = $Enabled
                endCursor = $response.data.cloudConfigurationRules.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.cloudConfigurationRules.nodes

        if ($response.data.cloudConfigurationRules.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
}