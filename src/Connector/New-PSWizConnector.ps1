function New-PSWizConnector {
    <#
    .SYNOPSIS
        Creates a new connector in the Wiz platform.

    .DESCRIPTION
        The New-PSWizConnector function creates a new Azure connector in the Wiz platform's API.
        It requires specifying the name, type, subscription ID, and tenant ID of the connector.
        The connector is created with the enabled status set to true and using managed identity.

    .PARAMETER Name
        Specifies the name of the connector to be created.
        This parameter is mandatory.

    .PARAMETER Type
        Specifies the type of the connector. The only supported value is 'azure'.
        This parameter is mandatory.
        Valid values: 'azure'

    .PARAMETER SubscriptionId
        Specifies the Azure subscription ID associated with the connector.
        This parameter is mandatory.

    .PARAMETER TenantId
        Specifies the Azure tenant ID associated with the connector.
        This parameter is mandatory.

    .EXAMPLE
        New-PSWizConnector -Name "MyConnector" -Type "azure" -SubscriptionId "12345678-1234-1234-1234-123456789012" -TenantId "87654321-4321-4321-4321-210987654321"
        This example creates a new Azure connector named "MyConnector" with the specified subscription ID and tenant ID.

    .OUTPUTS
        PSCustomObject
            The function returns the details of the created connector.
            If there are errors, the function returns the error messages.

    .NOTES
        The function constructs a GraphQL query from a local file named createConnector.graphql located in the .\graphql\ directory.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        The connector is created with the enabled status set to true and using managed identity.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Name,

        [Parameter(Mandatory)]
        [ValidateSet('azure')]
        $Type,

        [Parameter(Mandatory)]
        $SubscriptionId,

        [Parameter(Mandatory)]
        $TenantId

    )
    
    $Query = [PSCustomObject]@{
        operationName = "createConnector"
        query         = $(Get-Content .\graphql\createConnector.graphql -Raw )
        variables     = @{
            name       = $($Name)
            type       = $($Type)
            enabled    = $true
            authParams = $([PSCustomObject]@{
                    IsManagedIdentity = $true
                    SubscriptionId    = $SubscriptionId
                    TenantId          = $TenantId
                })
        }
    } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    if ($response.errors) {
        $response.errors
    }
    else {
        $response.data.createConnector.connector
    }
}