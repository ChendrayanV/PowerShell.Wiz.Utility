function Get-PSWizUser {
    <#
    .SYNOPSIS
        Retrieves user information from the Wiz platform based on the specified source.

    .DESCRIPTION
        The Get-PSWizUser function fetches user information from the Wiz platform's API.
        It retrieves all users filtered by the specified source, either 'MODERN' or 'LEGACY'.

    .PARAMETER Source
        Specifies the source of the users to retrieve.
        Valid values: 'MODERN', 'LEGACY'
        This parameter is mandatory.
        HelpMessage: Modern or Legacy

    .EXAMPLE
        Get-PSWizUser -Source 'MODERN'
        This example retrieves all users from the 'MODERN' source.

    .EXAMPLE
        Get-PSWizUser -Source 'LEGACY'
        This example retrieves all users from the 'LEGACY' source.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of users based on the specified source.

    .NOTES
        The function constructs a GraphQL query from a local file named getUser.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, HelpMessage = "Modern or Legacy")]
        [ValidateSet('MODERN' , 'LEGACY')]
        $Source
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getUser"
        query         = $(Get-Content .\graphql\getUser.graphql -Raw)
        variables     = @{
            source    = $Source
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getUser"
            query         = $(Get-Content .\graphql\getUser.graphql -Raw)
            variables     = @{
                source    = $Source
                endCursor = $response.data.users.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.users.nodes

        if ($response.data.users.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
    
}