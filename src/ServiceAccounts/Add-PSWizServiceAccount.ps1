function Add-PSWizServiceAccount {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Name,

        [Parameter(Mandatory)]
        $Scopes,

        [Parameter(Mandatory)]
        $AssignedProjectId,

        [Parameter(Mandatory)]
        [ValidateSet('THIRD_PARTY', 'SENSOR', 'KUBERNETES_ADMISSION_CONTROLLER', 'BROKER', 'FIRST_PARTY', 'KUBERNETES_CONNECTOR', 'INTEGRATION', 'OUTPOST')]
        $Type,

        [Parameter(Mandatory)]
        [datetime]
        $ExpiresAt
    )
    
    $Query = [PSCustomObject]@{
        operationName = "createServiceAccount"
        query         = $(Get-Content .\graphql\createServiceAccount.graphql -Raw)
        variables     = @{
            name               = $Name
            scopes             = @($Scopes)
            assignedProjectIds = @($AssignedProjectId)
            type               = $Type
            expiresAt          = $ExpiresAt
        }
    } | ConvertTo-Json -Compress
    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    if ($response.errors) {
        $response.errors
    }
    else {
        $response.data.createServiceAccount
    }

}

