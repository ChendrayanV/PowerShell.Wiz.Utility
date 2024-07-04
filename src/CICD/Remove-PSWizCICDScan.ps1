function Remove-PSWizCICDScan {
    <#
    .SYNOPSIS
        Deletes specified CICD scans from the Wiz platform.

    .DESCRIPTION
        The Remove-PSWizCICDScan function deletes CICD scans from the Wiz platform's API based on the provided scan IDs.
        It processes each ID and sends a request to delete the corresponding scan.

    .PARAMETER Id
        Specifies the IDs of the CICD scans to be deleted.
        This parameter is mandatory and accepts one or more IDs.
        This parameter supports pipeline input and can accept input by property name.

    .EXAMPLE
        Remove-PSWizCICDScan -Id "scan123", "scan456"
        This example deletes the CICD scans with IDs "scan123" and "scan456".

    .EXAMPLE
        "scan123", "scan456" | Remove-PSWizCICDScan
        This example deletes the CICD scans with IDs "scan123" and "scan456" using pipeline input.

    .OUTPUTS
        PSCustomObject
            The function returns the result of the deletion operation for each scan ID.
            If there are errors, the function returns the error messages.

    .NOTES
        The function constructs a GraphQL query from a local file named deleteCICDScan.graphql located in the .\graphql\ directory.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Id
    )
    
    begin {
        
    }
    
    process {
        foreach ($ScanId in $Id) {
            $Query = [PSCustomObject]@{
                operationName = "deleteCICDScan"
                query         = $(Get-Content .\graphql\deleteCICDScan.graphql -Raw)
                variables     = @{
                    id = $($ScanId)
                }
            } | ConvertTo-Json -Compress
            $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
            if ($response.errors) {
                $response.errors
            }
            else {
                $response.data.deleteCICDScan
            }
        }
    }
    
    end {
        
    }
}