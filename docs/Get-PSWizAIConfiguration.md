---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version: https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
schema: 2.0.0
---

# Get-PSWizAIConfiguration

## SYNOPSIS
Retrieves the AI configuration settings from the Wiz API.

## SYNTAX

```
Get-PSWizAIConfiguration
```

## DESCRIPTION
The Get-PSWizAIConfiguration function fetches AI configuration settings from the Wiz API using a GraphQL query.
The function constructs the query from a file located in the same directory as the script and sends a POST request to the Wiz API endpoint.
The function requires the API endpoint and access token to be stored in script scope variables.

## EXAMPLES

### EXAMPLE 1
```
Get-PSWizAIConfiguration
This example demonstrates how to call the function to retrieve AI configuration settings from the Wiz API. 
The output will be the AI settings if the request is successful.
```

## PARAMETERS

## INPUTS

## OUTPUTS

### PSCustomObject
###     The function outputs the AI configuration settings retrieved from the Wiz API.
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod](https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod)

