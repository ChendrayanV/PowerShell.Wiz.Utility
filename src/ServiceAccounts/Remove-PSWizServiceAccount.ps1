function Remove-PSWizServiceAccount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Id
    )
    
    
    process {
        foreach ($serviceAccountId in $Id) {
            $Query = [PSCustomObject]@{
                operationName = "deleteServiceAccount"
                query         = $(Get-Content .\graphql\deleteServiceAccount.graphql -Raw)
                variables     = @{
                    id = $serviceAccountId
                }
            } | ConvertTo-Json -Compress
            
            $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
            if ($response.errors) {
                $response.errors
            }
            else {
                $response.data.deleteServiceAccount
            }

        }
    }
}