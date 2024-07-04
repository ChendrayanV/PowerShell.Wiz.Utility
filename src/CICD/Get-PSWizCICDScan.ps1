function Get-PSWizCICDScan {
    <#
    .SYNOPSIS
        Retrieves CICD scan results from the Wiz platform based on the specified state.

    .DESCRIPTION
        The Get-PSWizCICDScan function fetches CICD scan results from the Wiz platform's API. 
        It allows filtering of scan results based on their state, such as SUCCESS, FAILURE, PENDING, or SKIPPED.

    .PARAMETER State
        Specifies the state of the CICD scans to retrieve.
        This parameter is mandatory.
        Valid values: 'SUCCESS', 'FAILURE', 'PENDING', 'SKIPPED'

    .EXAMPLE
        Get-PSWizCICDScan -State "SUCCESS"
        This example retrieves all CICD scans that have completed successfully.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of CICD scan results matching the specified state.

    .NOTES
        The function constructs a GraphQL query from a local file named getCICDScan.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('SUCCESS', 'FAILURE', 'PENDING', 'SKIPPED')]
        $State
    )
    
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "getCICDScan"
        query         = $(Get-Content -Path "$($queryPath)\graphql\getCICDScan.graphql" -Raw)
        variables     = @{
            state     = $State
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getCICDScan"
            query         = $(Get-Content -Path "$($queryPath)\graphql\getCICDScan.graphql" -Raw)
            variables     = @{
                state     = $State
                endCursor = $response.data.cicdScans.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.cicdScans.nodes

        if ($response.data.cicdScans.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
    
}