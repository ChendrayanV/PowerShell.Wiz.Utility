function New-PSWizServiceAccountSecret {
    <#
    .SYNOPSIS
        Rotates the secret for a specified service account in the Wiz platform.

    .DESCRIPTION
        The New-PSWizServiceAccountSecret function rotates the secret for a specified service account in the Wiz platform's API.
        It requires the client ID of the service account for which the secret needs to be rotated.

    .PARAMETER ClientID
        Specifies the client ID of the service account for which the secret is to be rotated.
        This parameter is mandatory.

    .EXAMPLE
        New-PSWizServiceAccountSecret -ClientID "client123"
        This example rotates the secret for the service account with the client ID "client123".

    .OUTPUTS
        PSCustomObject
            The function returns the details of the service account with the new secret.
            If there are errors, the function returns the error messages.

    .NOTES
        The function constructs a GraphQL query from a local file named rotateServiceAccountSecret.graphql located in the .\graphql\ directory.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        $ClientID
    )
    
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "rotateServiceAccountSecret"
        query         = $(Get-Content -Path "$($queryPath)\graphql\rotateServiceAccountSecret.graphql" -Raw)
        variables     = @{
            clientId = $ClientID
        }
    } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    if ($response.errors) {
        $response.errors
    }
    else {
        $response.data.rotateServiceAccountSecret.serviceAccount
    }

}