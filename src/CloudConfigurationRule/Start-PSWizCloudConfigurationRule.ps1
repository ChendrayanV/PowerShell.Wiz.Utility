function Start-PSWizCloudConfigurationRule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $ShortID
    )
    
    begin {
        
    }
    
    process {
        foreach ($Id in $ShortId) {
            $Query = [PSCustomObject]@{
                operationName = "runCloudConfigurationRule"
                query         = $(Get-Content .\graphql\runCloudConfigurationRule.graphql -Raw)
                variables     = @{
                    id = $Id
                }
            } | ConvertTo-Json -Compress
            $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
            if ($response.errors) {
                $response.errors
            }
            else {
                $response.runCloudConfigurationRule.rule
            }
        }
    }
    
    end {
        
    }
}