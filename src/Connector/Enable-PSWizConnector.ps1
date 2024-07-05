function Enable-PSWizConnector {
    <#
    .SYNOPSIS
    Enables specified connectors in the Wiz platform.

    .DESCRIPTION
    The Enable-PSWizConnector function enables connectors in the Wiz platform using their unique identifiers. It sends a GraphQL request to the Wiz API to perform the enable operation.

    .PARAMETER Id
    Specifies the ID(s) of the connector(s) to be enabled. This parameter is mandatory and accepts an array of strings. The IDs can be retrieved by using the Get-PSWizConnector cmdlet.

    .EXAMPLE
    Enable-PSWizConnector -Id "12345"
    This example enables the Wiz connector with the ID "12345".

    .EXAMPLE
    "12345","67890" | Enable-PSWizConnector
    This example enables the Wiz connectors with the IDs "12345" and "67890".

    .INPUTS
    String[]
    You can pipe an array of strings representing the connector IDs to this cmdlet.

    .OUTPUTS
    System.Object
    Returns the result of the enable operation. If there are errors, they will be output; otherwise, the data related to the enabled connector will be output.

    .NOTES
    The function constructs a GraphQL query from a local file named enableConnector.graphql located in the .\graphql\ directory. Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope. PowerShell 5.0 or higher is required.

    .LINK
    Get-PSWizConnector
    https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding(ConfirmImpact = "High")]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Id
    )
    
    process {
        $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)
        foreach ($connectorId in $Id) {
            $Query = [PSCustomObject]@{
                operationName = "enableConnector"
                query         = $(Get-Content -Path "$($queryPath)\graphql\enableConnector.graphql" -Raw)
                variables     = @{
                    id = $($connectorId)
                }
            } | ConvertTo-Json -Compress
            $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
            if ($response.errors) {
                $response.errors
            }
            else {
                $response.data.updateConnector.connector
            }
        }
    }
}