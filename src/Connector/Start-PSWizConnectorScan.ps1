function Start-PSWizConnectorScan {
    <#
    .SYNOPSIS
        Initiates a scan for specified connectors in the Wiz platform.

    .DESCRIPTION
        The Start-PSWizConnectorScan function initiates a scan for one or more specified connectors
        in the Wiz platform's API. Users can specify whether to omit security tool scans and/or data scans
        for each connector.

    .PARAMETER ConnectorId
        Specifies the IDs of the connectors to be scanned.
        This parameter is mandatory and accepts one or more IDs.
        This parameter supports pipeline input and can accept input by property name.

    .PARAMETER OmitSecurityToolScan
        Specifies whether to omit the security tool scan for the connectors.
        This parameter is mandatory.
        Valid values: $true, $false

    .PARAMETER OmitDataScan
        Specifies whether to omit the data scan for the connectors.
        This parameter is mandatory.
        Valid values: $true, $false

    .EXAMPLE
        Start-PSWizConnectorScan -ConnectorId "conn123", "conn456" -OmitSecurityToolScan $true -OmitDataScan $false
        This example initiates a scan for the connectors with IDs "conn123" and "conn456", omitting the security tool scan but including the data scan.

    .EXAMPLE
        "conn123", "conn456" | Start-PSWizConnectorScan -OmitSecurityToolScan $false -OmitDataScan $true
        This example initiates a scan for the connectors with IDs "conn123" and "conn456" using pipeline input, omitting the data scan but including the security tool scan.

    .OUTPUTS
        PSCustomObject
            The function returns the result of the scan initiation operation for each connector ID.
            If there are errors, the function returns the error messages.

    .NOTES
        The function constructs a GraphQL query from a local file named requestConnectorScan.graphql located in the .\graphql\ directory.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $ConnectorId,

        [Parameter(Mandatory)]
        [bool]
        $OmitSecurityToolScan,

        [Parameter(Mandatory)]
        [bool]
        $OmitDataScan

    )
    
    begin {
        
    }
    
    process {
        $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)
        foreach ($Id in $ConnectorId) {
            $Query = [PSCustomObject]@{
                operationName = "requestConnectorScan"
                query         = $(Get-Content -Path "$($queryPath)\graphql\requestConnectorScan.graphql" -Raw)
                variables     = @{
                    id                   = $($Id)
                    omitSecurityToolScan = $($OmitSecurityToolScan)
                    omitDataScan         = $($OmitDataScan)
                }
            } | ConvertTo-Json -Compress
            $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
            if ($response.errors) {
                $response.errors
            }
            else {
                $response.data.requestConnectorScan.scan
            }
        }
    }
    
    end {
        
    }
}