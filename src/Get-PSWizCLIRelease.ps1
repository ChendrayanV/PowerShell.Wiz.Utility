function Get-PSWizCLIRelease {
    <#
    .SYNOPSIS
        A short one-line action-based description, e.g. 'Tests if a function is valid'
    .DESCRIPTION
        A longer description of the function, its purpose, common use cases, etc.
    .NOTES
        Information or caveats about the function e.g. 'This function is not supported in Linux'
    .LINK
        Specify a URI to a help page, this will show when Get-Help -Online is used.
    .EXAMPLE
        Test-MyTestFunction -Verbose
        Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
    #>
    
    
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Provide a business impact, low, medium or high")]
        [ValidateSet('WINDOWS', 'LINUX', 'DARWIN', 'DOCKER_LINUX')]
        $Platform
    )
    
    $Query = [PSCustomObject]@{
        operationName = "getCLIRelease"
        query         = $(Get-Content .\graphql\getCLIRelease.graphql -Raw)
        variables     = @{
            platform  = $Platform
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getCLIRelease"
            query         = $(Get-Content .\graphql\getCLIRelease.graphql -Raw)
            variables     = @{
                platform  = $Platform
                endCursor = $response.data.cliReleases.pageInfo.endCursor
            }
        } | ConvertTo-Json -Compress
        $Collection += $response.data.cliReleases.nodes

        if ($response.data.cliReleases.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
    
}