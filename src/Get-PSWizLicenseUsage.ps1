function Get-PSWizLicenseUsage {
    <#
    .SYNOPSIS
        Retrieves license usage information for the specified date range from the PSWiz API.

    .DESCRIPTION
        The Get-PSWizLicenseUsage function retrieves license usage data from the PSWiz API based on the provided start and end dates.
        It constructs a GraphQL query using a query template file and sends the request to the PSWiz API endpoint.

    .PARAMETER StartDate
        The start date of the date range for which to retrieve license usage data. This parameter is mandatory.

    .PARAMETER EndDate
        The end date of the date range for which to retrieve license usage data. This parameter is mandatory.

    .EXAMPLE
        PS C:\> Get-PSWizLicenseUsage -StartDate "2023-01-01" -EndDate "2023-01-31"
        
        This command retrieves the license usage data for the month of January 2023.

    .EXAMPLE
        PS C:\> $start = Get-Date "2023-01-01"
        PS C:\> $end = Get-Date "2023-01-31"
        PS C:\> Get-PSWizLicenseUsage -StartDate $start -EndDate $end
        
        This command retrieves the license usage data for the month of January 2023 using datetime objects for the StartDate and EndDate parameters.

    .NOTES
        The function requires a GraphQL query template file named 'getLicensesUsage.graphql' located in a 'graphql' subfolder of the script's directory.
        It also requires that the script-level variables $Script:Data_Center and $Script:Access_Token be set with the appropriate values for the API endpoint and authentication.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [datetime]
        $StartDate,

        [Parameter(Mandatory)]
        [datetime]
        $EndDate
    )
    
    $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)

    $Query = [PSCustomObject]@{
        operationName = "getLicensesUsage"
        query         = $(Get-Content -Path "$($queryPath)\graphql\getLicensesUsage.graphql" -Raw)
        variables     = @{
            monthStartDate = $StartDate
            monthEndDate   = $EndDate
        }
    } | ConvertTo-Json -Compress

    $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
    
    if ($response.errors) {
        $response.errors
    }
    else {
        $response.data.billableWorkloadTrend
    }
}