function Get-PSWizUser {
    
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Project GUID")]
        [ValidateSet('MODERN' , 'LEGACY')]
        $Source
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getUser"
        query         = $(Get-Content .\graphql\getUser.graphql -Raw)
        variables     = @{
            source    = $Source
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getUser"
            query         = $(Get-Content .\graphql\getUser.graphql -Raw)
            variables     = @{
                source    = $Source
                endCursor = $response.data.users.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.users.nodes

        if ($response.data.users.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
    
}