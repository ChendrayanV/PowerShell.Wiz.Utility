function Remove-PSWizConnector {
    <#
    .SYNOPSIS
    Removes specified connectors from the Wiz platform.

    .DESCRIPTION
    The Remove-PSWizConnector function deletes connectors from the Wiz platform using their unique identifiers. It sends a GraphQL request to the Wiz API to perform the deletion operation.

    .PARAMETER Id
    Specifies the ID(s) of the connector(s) to be removed. This parameter is mandatory and accepts an array of strings. The IDs can be retrieved by using the Get-PSWizConnector cmdlet.

    .EXAMPLE
    Remove-PSWizConnector -Id "12345"
    This example removes the Wiz connector with the ID "12345".

    .EXAMPLE
    "12345","67890" | Remove-PSWizConnector
    This example removes the Wiz connectors with the IDs "12345" and "67890".

    .OUTPUTS
    System.Object
    The function returns the result of the deletion operation. If there are errors, the function outputs the error messages; otherwise, it outputs the data related to the deleted connector.

    .NOTES
    The function constructs a GraphQL query from a local file named deleteConnector.graphql located in the .\graphql\ directory. Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope. PowerShell 5.0 or higher is required.

    .LINK
    https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding(ConfirmImpact = "High")]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = 'Connector Id, run Get-PSWizConnector to get the connector Ids')]
        [string[]]
        $Id
    )
    
    begin {
        
    }
    
    process {
        $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)
        foreach ($connectorId in $Id) {
            $Query = [PSCustomObject]@{
                operationName = "deleteConnector"
                query         = $(Get-Content -Path "$($queryPath)\graphql\deleteConnector.graphql" -Raw)
                variables     = @{
                    id = $($connectorId)
                }
            } | ConvertTo-Json -Compress
            $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
            if ($response.errors) {
                $response.errors
            }
            else {
                $response.data.deleteConnector
            }
        }
    }
    
    end {
        
    }
}