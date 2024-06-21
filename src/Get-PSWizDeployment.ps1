function Get-PSWizDeployment {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Shows all deployment",ParameterSetName = 'All')]
        [switch]
        $All,

        [Parameter(HelpMessage = "Shows Enabled or Disabled status of the deployment",ParameterSetName = 'Status')]
        [ValidateSet('Enabled' , 'Disabled')]
        $Status
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getDeployment"
        query         = $(Get-Content .\graphql\getDeployment.graphql -Raw)
        variables     = @{
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getDeployment"
            query         = $(Get-Content .\graphql\getDeployment.graphql -Raw)
            variables     = @{
                endCursor = $response.data.deployments.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.deployments.nodes

        if ($response.data.deployments.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    # $Collection
    switch ($PSCmdlet.ParameterSetName) {
        'All' {
            $Collection
        }
        'Status' {
            ($Collection).Where({$_.status -eq $($Status) })
        }
    }
}