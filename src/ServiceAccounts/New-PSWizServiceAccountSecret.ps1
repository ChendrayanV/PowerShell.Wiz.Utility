function New-PSWizServiceAccountSecret {
    [CmdletBinding()]
    param (
        $ClientID
    )
    
    $Query = [PSCustomObject]@{
        operationName = "rotateServiceAccountSecret"
        query         = $(Get-Content .\graphql\rotateServiceAccountSecret.graphql -Raw)
        variables     = @{
            clientId = $ClientID
        }
    } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    if ($response.errors) {
        $response.errors
    }
    else {
        $response.data.rotateServiceAccountSecret.serviceAccount
    }

}