function Get-PSWizSecurityFramework {
    <#
    .SYNOPSIS
        Retrieves security framework information from the Wiz platform.

    .DESCRIPTION
        The Get-PSWizSecurityFramework function fetches security framework information from the Wiz platform's API.
        It retrieves all available security frameworks and filters them based on the BuiltIn parameter if specified.

    .PARAMETER BuiltIn
        Specifies whether to filter the security frameworks based on whether they are built-in.
        Valid values: $true, $false
        HelpMessage: Builtin

    .EXAMPLE
        Get-PSWizSecurityFramework -BuiltIn $true
        This example retrieves all built-in security frameworks.

    .EXAMPLE
        Get-PSWizSecurityFramework
        This example retrieves all security frameworks without filtering.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of security frameworks.
            If the BuiltIn parameter is specified, the collection is filtered based on its value.

    .NOTES
        The function constructs a GraphQL query from a local file named getSecurityFramework.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        If the BuiltIn parameter is specified, the function filters the results based on whether the frameworks are built-in.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Builtin")]
        [bool]
        $BuiltIn
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getSecurityFramework"
        query         = $(Get-Content .\graphql\getSecurityFramework.graphql -Raw)
        variables     = @{
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getSecurityFramework"
            query         = $(Get-Content .\graphql\getSecurityFramework.graphql -Raw)
            variables     = @{
                endCursor = $response.data.securityFrameworks.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.securityFrameworks.nodes

        if ($response.data.securityFrameworks.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('BuiltIn')) {
        ($Collection).Where({ $_.builtin -eq $BuiltIn })
    }
    
    
}