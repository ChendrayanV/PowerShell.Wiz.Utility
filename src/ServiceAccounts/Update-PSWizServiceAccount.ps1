function Update-PSWizServiceAccount {
    <#
    .SYNOPSIS
        Updates the specified service account in the Wiz platform.

    .DESCRIPTION
        The Update-PSWizServiceAccount function updates the details of an existing service account in the Wiz platform's API.
        It allows updating the scopes and expiration date of the service account based on the provided service account ID.

    .PARAMETER ServiceAccountId
        Specifies the ID of the service account to be updated.
        This parameter is mandatory.

    .PARAMETER Scopes
        Specifies the new scopes to be assigned to the service account.
        This parameter is mandatory and should be an array of scope strings.

    .PARAMETER ExpiresAt
        Specifies the new expiration date and time for the service account.
        This parameter is mandatory and should be a datetime object.

    .EXAMPLE
        Update-PSWizServiceAccount -ServiceAccountId "account123" -Scopes "scope1", "scope2" -ExpiresAt (Get-Date).AddMonths(6)
        This example updates the service account with ID "account123" by setting new scopes and an expiration date six months from the current date.

    .OUTPUTS
        PSCustomObject
            The function returns the details of the updated service account.
            If there are errors, the function returns the error messages.

    .NOTES
        The function constructs a GraphQL query from a local file named updateServiceAccount.graphql located in the .\graphql\ directory.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $ServiceAccountId,

        [Parameter(Mandatory)]
        $Scopes,

        [Parameter(Mandatory)]
        [datetime]
        $ExpiresAt
    )
    
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "updateServiceAccount"
        query         = $(Get-Content "$($queryPath)\graphql\updateServiceAccount.graphql" -Raw)
        variables     = @{
            serviceAccountId = $ServiceAccountId
            scopes           = @($Scopes)
            expiresAt        = $ExpiresAt
        }
    } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    if ($response.errors) {
        $response.errors
    }
    else {
        $response.data.updateServiceAccount.serviceAccount
    }

}

