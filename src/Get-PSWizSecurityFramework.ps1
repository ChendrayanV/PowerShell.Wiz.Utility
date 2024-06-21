function Get-PSWizSecurityFramework {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Builtin")]
        [bool]
        $BuiltIn
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getSecurityFramework"
        query         = $(Get-Content .\graphql\getSecurityFramework.graphql -Raw)
        variables     = @{
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getSecurityFramework"
            query         = $(Get-Content .\graphql\getSecurityFramework.graphql -Raw)
            variables     = @{
                endCursor = $response.data.securityFrameworks.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.securityFrameworks.nodes

        if ($response.data.securityFrameworks.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('BuiltIn')) {
        ($Collection).Where({ $_.builtin -eq $BuiltIn })
    }
    
    
}