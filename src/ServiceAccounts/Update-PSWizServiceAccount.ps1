function Update-PSWizServiceAccount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $ServiceAccountId,

        [Parameter(Mandatory)]
        $Scopes,

        [Parameter(Mandatory)]
        [datetime]
        $ExpiresAt
    )
    
    $Query = [PSCustomObject]@{
        operationName = "updateServiceAccount"
        query         = $(Get-Content .\graphql\updateServiceAccount.graphql -Raw)
        variables     = @{
            serviceAccountId = $ServiceAccountId
            scopes           = @($Scopes)
            expiresAt        = $ExpiresAt
        }
    } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    if ($response.errors) {
        $response.errors
    }
    else {
        $response.data.updateServiceAccount.serviceAccount
    }

}

