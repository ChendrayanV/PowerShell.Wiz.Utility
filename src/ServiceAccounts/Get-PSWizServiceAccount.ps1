function Get-PSWizServiceAccount {
    <#
    .SYNOPSIS
        Retrieves service account information from the Wiz platform.

    .DESCRIPTION
        The Get-PSWizServiceAccount function fetches service account information from the Wiz platform's API.
        It can retrieve details for a specific service account based on the provided client ID.

    .PARAMETER ClientId
        Specifies the client ID of the service account to retrieve.
        This parameter is optional.
        HelpMessage: Client Identity

    .EXAMPLE
        Get-PSWizServiceAccount -ClientId "client123"
        This example retrieves the service account information for the client ID "client123".

    .EXAMPLE
        Get-PSWizServiceAccount
        This example retrieves all service account information if no client ID is provided.

    .OUTPUTS
        PSCustomObject
            The function returns the details of the specified service account.
            If no client ID is provided, it returns all service accounts.

    .NOTES
        The function constructs a GraphQL query from a local file named getServiceAccount.graphql located in the .\graphql\ directory.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Client Identity")]
        [string]
        $ClientId
    )

    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)
    
    $Query = [PSCustomObject]@{
        operationName = "getServiceAccount"
        query         = $(Get-Content "$($queryPath)\graphql\getServiceAccount.graphql" -Raw)
        variables     = @{
            clientId  = $ClientId
        }
    } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    $response.data.serviceAccount
    
}