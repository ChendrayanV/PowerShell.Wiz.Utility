function Remove-PSWizServiceAccount {
    <#
    .SYNOPSIS
        Deletes specified service accounts from the Wiz platform.

    .DESCRIPTION
        The Remove-PSWizServiceAccount function deletes service accounts from the Wiz platform's API based on the provided service account IDs.
        It processes each ID and sends a request to delete the corresponding service account.

    .PARAMETER Id
        Specifies the IDs of the service accounts to be deleted.
        This parameter is mandatory and accepts one or more IDs.
        This parameter supports pipeline input and can accept input by property name.

    .EXAMPLE
        Remove-PSWizServiceAccount -Id "account123", "account456"
        This example deletes the service accounts with IDs "account123" and "account456".

    .EXAMPLE
        "account123", "account456" | Remove-PSWizServiceAccount
        This example deletes the service accounts with IDs "account123" and "account456" using pipeline input.

    .OUTPUTS
        PSCustomObject
            The function returns the result of the deletion operation for each service account ID.
            If there are errors, the function returns the error messages.

    .NOTES
        The function constructs a GraphQL query from a local file named deleteServiceAccount.graphql located in the .\graphql\ directory.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $Id
    )
    
    
    process {
        $queryPath = $(Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent)
        foreach ($serviceAccountId in $Id) {
            $Query = [PSCustomObject]@{
                operationName = "deleteServiceAccount"
                query         = $(Get-Content "$($queryPath)\graphql\deleteServiceAccount.graphql" -Raw)
                variables     = @{
                    id = $serviceAccountId
                }
            } | ConvertTo-Json -Compress
            
            $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
            if ($response.errors) {
                $response.errors
            }
            else {
                $response.data.deleteServiceAccount
            }

        }
    }
}