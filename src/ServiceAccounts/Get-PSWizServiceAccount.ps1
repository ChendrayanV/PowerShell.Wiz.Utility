function Get-PSWizServiceAccount {
    
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Client Identity")]
        [string]
        $ClientId
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getServiceAccount"
        query         = $(Get-Content .\graphql\getServiceAccount.graphql -Raw)
        variables     = @{
            clientId  = $ClientId
        }
    } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    $response.data.serviceAccount
    
}