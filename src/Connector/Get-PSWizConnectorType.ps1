function Get-PSWizConnectorType {
    <#
    .SYNOPSIS
        Retrieves connector types from the Wiz platform.

    .DESCRIPTION
        The Get-PSWizConnectorType function fetches connector type information from the Wiz platform's API.
        It retrieves all available connector types and compiles them into a collection.

    .PARAMETER Id
        Specifies the ID of the connector type to retrieve.
        HelpMessage: Provide Connecty ID (aws, azure, ecr)
        This parameter is optional and can be used to filter the results based on a specific connector type ID.

    .EXAMPLE
        Get-PSWizConnectorType -Id "aws"
        This example retrieves the connector type information for the 'aws' connector type.

    .EXAMPLE
        Get-PSWizConnectorType
        This example retrieves all available connector types.

    .OUTPUTS
        PSCustomObject
            The function returns a collection of connector types.

    .NOTES
        The function constructs a GraphQL query from a local file named getConnectorType.graphql located in the .\graphql\ directory.
        The function uses a loop to handle pagination and retrieve all pages of results.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Provide Connecty ID (aws, azure, ecr)")]
        $Id
    )
    
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "getConnectorType"
        query         = $(Get-Content -Path "$($queryPath)\graphql\getConnectorType.graphql" -Raw)
        
    } | ConvertTo-Json -Compress
    $Collection = @()

    while ($true) {
        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        $Query = [PSCustomObject]@{
            operationName = "getConnectorType"
            query         = $(Get-Content -Path "$($queryPath)\graphql\getConnectorType.graphql" -Raw)
            
        } | ConvertTo-Json -Compress
        $Collection += $response.data.connectorTypes.nodes

        if ($response.data.connectorTypes.pageInfo.hasNextPage -eq $false) {
            break
        }
    }

    $Collection
    
}