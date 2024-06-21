function Remove-PSWizCloudConfigurationRule {
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