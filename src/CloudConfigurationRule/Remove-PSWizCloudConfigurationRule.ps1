function Remove-PSWizCloudConfigurationRule {
    <#
    .SYNOPSIS
        Deletes specified cloud configuration rules from the Wiz platform.

    .DESCRIPTION
        The Remove-PSWizCloudConfigurationRule function deletes cloud configuration rules from the Wiz platform's API based on the provided rule IDs.
        It processes each ID and sends a request to delete the corresponding rule.

    .PARAMETER Id
        Specifies the IDs of the cloud configuration rules to be deleted.
        This parameter is mandatory and accepts one or more IDs.
        This parameter supports pipeline input and can accept input by property name.
        HelpMessage: GUID of Cloud Configuration Rule

    .EXAMPLE
        Remove-PSWizCloudConfigurationRule -Id "rule123", "rule456"
        This example deletes the cloud configuration rules with IDs "rule123" and "rule456".

    .EXAMPLE
        "rule123", "rule456" | Remove-PSWizCloudConfigurationRule
        This example deletes the cloud configuration rules with IDs "rule123" and "rule456" using pipeline input.

    .OUTPUTS
        PSCustomObject
            The function returns the result of the deletion operation for each rule ID.
            If there are errors, the function returns the error messages.

    .NOTES
        The function constructs a GraphQL mutation query to delete the specified cloud configuration rule.
        Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
        The function has a high confirm impact due to the deletion operation.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding(ConfirmImpact = "High")]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "GUID of Cloud Configuration Rule")]
        [string[]]
        $Id
    )
    
    begin {
        
    }
    
    process {
        
        foreach ($item in $id) {
            $Query = @{
                query = @"
                    mutation {
                        deleteCloudConfigurationRule(input: {id: "$($item)"}) {
                            _stub
                            __typename
                        }
                    }
"@
            } | ConvertTo-Json -Compress
        }

        $response = Invoke-RestMethod -Uri "https://api.$($Script:Data_Center).app.wiz.io/graphql" -Headers @{Authorization = "Bearer $($Script:Access_Token)" } -Method Post -Body $Query -ContentType 'application/json'
        if ($response.errors) {
            $response.errors
        }
        else {
            $response
        }
    }
    
    end {
        
    }
}