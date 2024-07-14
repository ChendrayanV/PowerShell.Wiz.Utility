---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version:
schema: 2.0.0
---

# Get-PSWizHostConfigurationRule

## SYNOPSIS
Retrieves host configuration rules from the Wiz API using GraphQL queries.

## SYNTAX

```
Get-PSWizHostConfigurationRule
```

## DESCRIPTION
The \`Get-PSWizHostConfigurationRule\` function is designed to fetch host configuration rules from the Wiz API.
It uses GraphQL queries to retrieve the data, handling pagination to ensure all relevant data is collected.

## EXAMPLES

### EXAMPLE 1
```
Get-PSWizHostConfigurationRule
```

This example runs the function and retrieves all host configuration rules from the Wiz API.

## PARAMETERS

## INPUTS

### None. You cannot pipe objects to this function.
## OUTPUTS

### Array of PSCustomObject
### The function returns an array of PSCustomObject, each representing a host configuration rule retrieved from the Wiz API.
## NOTES
- This function requires the script to have access to the Wiz API endpoint and appropriate authorization tokens.
- The function handles pagination to ensure all data is retrieved.
- The GraphQL query is expected to be located in the 'graphql' subdirectory relative to the script's location.

## RELATED LINKS
