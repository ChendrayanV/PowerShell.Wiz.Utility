function Get-PSWizDeployment {
    <#
    .SYNOPSIS
        Retrieves deployment information from the Wiz platform.

    .DESCRIPTION
        The Get-PSWizDeployment function fetches deployment information from the Wiz platform's API.
        It can retrieve all deployments or filter them based on their status (Enabled or Disabled).

    .PARAMETER All
        If specified, retrieves all deployments without filtering by status.
        This parameter belongs to the 'All' parameter set.
        HelpMessage: Shows all deployment

    .PARAMETER Status
        Specifies the status of the deployments to retrieve.
        Valid values: 'Enabled', 'Disabled'
        This parameter belongs to the 'Status' parameter set.
        HelpMessage: Shows Enabled or Disabled status of the deployment

    .EXAMPLE
        Get-PSWizDeployment -All
        This example retrieves all deployments without any status filter.

    .EXAMPLE
        Get-PSWizDeployment -Status 'Enabled'
        This example retrieves all deployments that are currently enabled.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of deployments.
            If the All parameter is specified, all deployments are returned.
            If the Status parameter is specified, deployments are filtered based on the provided status.

    .NOTES
        The function constructs a GraphQL query from a local file named getDeployment.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Shows all deployment",ParameterSetName = 'All')]
        [switch]
        $All,

        [Parameter(HelpMessage = "Shows Enabled or Disabled status of the deployment",ParameterSetName = 'Status')]
        [ValidateSet('Enabled' , 'Disabled')]
        $Status
    )
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)
    $Query = [PSCustomObject]@{
        operationName = "getDeployment"
        query         = $(Get-Content -Path "$($queryPath)\graphql\getDeployment.graphql" -Raw)
        variables     = @{
            endCursor = $null
        }
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getDeployment"
            query         = $(Get-Content -Path "$($queryPath)\graphql\getDeployment.graphql" -Raw)
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