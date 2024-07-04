function Get-PSWizCICDScanPolicy {
    <#
    .SYNOPSIS
        Retrieves CICD scan policies from the Wiz platform based on whether they are built-in or custom.

    .DESCRIPTION
        The Get-PSWizCICDScanPolicy function fetches CICD scan policies from the Wiz platform's API.
        It allows filtering of scan policies based on whether they are built-in or custom policies.

    .PARAMETER BuiltIn
        Specifies whether to retrieve built-in scan policies.
        This parameter is mandatory.
        Valid values: $true, $false

    .EXAMPLE
        Get-PSWizCICDScanPolicy -BuiltIn $true
        This example retrieves all built-in CICD scan policies.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of CICD scan policies based on the specified filter.

    .NOTES
        The function constructs a GraphQL query from a local file named getCICDScanPolicy.graphql located in the .\graphql\ directory.
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
        $BuiltIn
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getCICDScanPolicy"
        query         = $(Get-Content .\graphql\getCICDScanPolicy.graphql -Raw)
        variables     = @{
            builtIn   = $BuiltIn
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getCICDScanPolicy"
            query         = $(Get-Content .\graphql\getCICDScanPolicy.graphql -Raw)
            variables     = @{
                builtIn   = $BuiltIn
                
                endCursor = $response.data.cicdScanPolicies.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.cicdScanPolicies.nodes

        if ($response.data.cicdScanPolicies.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
    
}