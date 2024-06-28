function Remove-PSWizCICDScan {
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