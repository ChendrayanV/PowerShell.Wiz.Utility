---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version:
schema: 2.0.0
---

# Get-PSWizWorkLogScanTable

## SYNOPSIS
Retrieves workload scan logs from Wiz.io API.

## SYNTAX

```
Get-PSWizWorkLogScanTable [<CommonParameters>]
```

## DESCRIPTION
The \`Get-PSWizWorkLogScanTable\` function queries the Wiz.io API to retrieve workload scan logs.
The function makes use of GraphQL queries and handles pagination automatically to collect all available logs.

## EXAMPLES

### EXAMPLE 1
```
Get-PSWizWorkLogScanTable
```

This example retrieves all workload scan logs and returns them as a collection of objects.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The function relies on a GraphQL query file named \`getWorkloadScanLogTable.graphql\` located in a subdirectory named \`graphql\` relative to the script's path.
It also requires that the script variables \`$Script:Data_Center\` and \`$Script:Access_Token\` are set with the appropriate Wiz.io API data center and access token, respectively.
    - PowerShell 5.1 or later
    - Invoke-RestMethod cmdlet
    - The GraphQL query file \`getWorkloadScanLogTable.graphql\` must be present in the \`graphql\` directory relative to the script's location.

## RELATED LINKS
