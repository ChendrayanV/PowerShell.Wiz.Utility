function Add-PSWizServiceAccount {
    <#
    .SYNOPSIS
        Creates a new service account in the Wiz platform.

    .DESCRIPTION
        The Add-PSWizServiceAccount function creates a new service account in the Wiz platform's API.
        It requires specifying the name, scopes, assigned project ID, type, and expiration date of the service account.

    .PARAMETER Name
        Specifies the name of the service account to be created.
        This parameter is mandatory.

    .PARAMETER Scopes
        Specifies the scopes assigned to the service account.
        This parameter is mandatory and should be an array of scope strings.

    .PARAMETER AssignedProjectId
        Specifies the project ID to which the service account is assigned.
        This parameter is mandatory.

    .PARAMETER Type
        Specifies the type of the service account.
        Valid values: 'THIRD_PARTY', 'SENSOR', 'KUBERNETES_ADMISSION_CONTROLLER', 'BROKER', 'FIRST_PARTY', 'KUBERNETES_CONNECTOR', 'INTEGRATION', 'OUTPOST'
        This parameter is mandatory.

    .PARAMETER ExpiresAt
        Specifies the expiration date and time for the service account.
        This parameter is mandatory and should be a datetime object.

    .EXAMPLE
        Add-PSWizServiceAccount -Name "ServiceAccount1" -Scopes "scope1", "scope2" -AssignedProjectId "project123" -Type "THIRD_PARTY" -ExpiresAt (Get-Date).AddMonths(6)
        This example creates a new service account named "ServiceAccount1" with specified scopes, assigned project ID, type, and an expiration date six months from the current date.

    .OUTPUTS
        PSCustomObject
            The function returns the details of the created service account.
            If there are errors, the function returns the error messages.

    .NOTES
        The function constructs a GraphQL query from a local file named createServiceAccount.graphql located in the .\graphql\ directory.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Name,

        [Parameter(Mandatory)]
        $Scopes,

        [Parameter(Mandatory)]
        $AssignedProjectId,

        [Parameter(Mandatory)]
        [ValidateSet('THIRD_PARTY', 'SENSOR', 'KUBERNETES_ADMISSION_CONTROLLER', 'BROKER', 'FIRST_PARTY', 'KUBERNETES_CONNECTOR', 'INTEGRATION', 'OUTPOST')]
        $Type,

        [Parameter(Mandatory)]
        [datetime]
        $ExpiresAt
    )
    
    $Query = [PSCustomObject]@{
        operationName = "createServiceAccount"
        query         = $(Get-Content .\graphql\createServiceAccount.graphql -Raw)
        variables     = @{
            name               = $Name
            scopes             = @($Scopes)
            assignedProjectIds = @($AssignedProjectId)
            type               = $Type
            expiresAt          = $ExpiresAt
        }
    } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    if ($response.errors) {
        $response.errors
    }
    else {
        $response.data.createServiceAccount
    }

}

