function Start-PSWizCloudConfigurationRule {
    <#
    .SYNOPSIS
        Starts specified cloud configuration rules in the Wiz platform.

    .DESCRIPTION
        The Start-PSWizCloudConfigurationRule function initiates the execution of cloud configuration rules
        in the Wiz platform's API based on the provided rule short IDs. It processes each ID and sends a request
        to start the corresponding rule.

    .PARAMETER ShortID
        Specifies the short IDs of the cloud configuration rules to be started.
        This parameter is mandatory and accepts one or more IDs.
        This parameter supports pipeline input and can accept input by property name.

    .EXAMPLE
        Start-PSWizCloudConfigurationRule -ShortID "short123", "short456"
        This example starts the cloud configuration rules with short IDs "short123" and "short456".

    .EXAMPLE
        "short123", "short456" | Start-PSWizCloudConfigurationRule
        This example starts the cloud configuration rules with short IDs "short123" and "short456" using pipeline input.

    .OUTPUTS
        PSCustomObject
            The function returns the result of the initiation operation for each rule short ID.
            If there are errors, the function returns the error messages.

    .NOTES
        The function constructs a GraphQL query from a local file named runCloudConfigurationRule.graphql located in the .\graphql\ directory.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]
        $ShortID
    )
    
    begin {
        
    }
    
    process {
        foreach ($Id in $ShortId) {
            $Query = [PSCustomObject]@{
                operationName = "runCloudConfigurationRule"
                query         = $(Get-Content .\graphql\runCloudConfigurationRule.graphql -Raw)
                variables     = @{
                    id = $Id
                }
            } | ConvertTo-Json -Compress
            $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
            if ($response.errors) {
                $response.errors
            }
            else {
                $response.runCloudConfigurationRule.rule
            }
        }
    }
    
    end {
        
    }
}