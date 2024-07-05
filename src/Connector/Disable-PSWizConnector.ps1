function Disable-PSWizConnector {
    <#
    .SYNOPSIS
    Disables specified connectors in the Wiz platform.

    .DESCRIPTION
    The Disable-PSWizConnector function disables connectors in the Wiz platform using their unique identifiers. It sends a GraphQL request to the Wiz API to perform the disable operation.

    .PARAMETER Id
    Specifies the ID(s) of the connector(s) to be disabled. This parameter is mandatory and accepts an array of strings. The IDs can be retrieved by using the Get-PSWizConnector cmdlet.

    .EXAMPLE
    Disable-PSWizConnector -Id "12345"
    This example disables the Wiz connector with the ID "12345".

    .EXAMPLE
    "12345","67890" | Disable-PSWizConnector
    This example disables the Wiz connectors with the IDs "12345" and "67890".

    .INPUTS
    String[]
    You can pipe an array of strings representing the connector IDs to this cmdlet.

    .OUTPUTS
    System.Object
    Returns the result of the disable operation. If there are errors, they will be output; otherwise, the data related to the disabled connector will be output.

    .NOTES
    The function constructs a GraphQL query from a local file named disableConnector.graphql located in the .\graphql\ directory. Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope. PowerShell 5.0 or higher is required.

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
    
    begin {
        
    }
    
    process {
        $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)
        foreach ($connectorId in $Id) {
            $Query = [PSCustomObject]@{
                operationName = "disableConnector"
                query         = $(Get-Content -Path "$($queryPath)\graphql\disableConnector.graphql" -Raw)
                variables     = @{
                    id      = $($connectorId)
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
    
    end {
        
    }
}