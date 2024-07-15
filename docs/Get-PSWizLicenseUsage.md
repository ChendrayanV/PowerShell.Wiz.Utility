---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version:
schema: 2.0.0
---

# Get-PSWizLicenseUsage

## SYNOPSIS
Retrieves license usage information for the specified date range from the PSWiz API.

## SYNTAX

```
Get-PSWizLicenseUsage [-StartDate] <DateTime> [-EndDate] <DateTime> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-PSWizLicenseUsage function retrieves license usage data from the PSWiz API based on the provided start and end dates.
It constructs a GraphQL query using a query template file and sends the request to the PSWiz API endpoint.

## EXAMPLES

### EXAMPLE 1
```
Get-PSWizLicenseUsage -StartDate "2023-01-01" -EndDate "2023-01-31"
```

This command retrieves the license usage data for the month of January 2023.

### EXAMPLE 2
```
$start = Get-Date "2023-01-01"
PS C:\> $end = Get-Date "2023-01-31"
PS C:\> Get-PSWizLicenseUsage -StartDate $start -EndDate $end
```

This command retrieves the license usage data for the month of January 2023 using datetime objects for the StartDate and EndDate parameters.

## PARAMETERS

### -EndDate
The end date of the date range for which to retrieve license usage data.
This parameter is mandatory.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
The start date of the date range for which to retrieve license usage data.
This parameter is mandatory.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The function requires a GraphQL query template file named 'getLicensesUsage.graphql' located in a 'graphql' subfolder of the script's directory.
It also requires that the script-level variables $Script:Data_Center and $Script:Access_Token be set with the appropriate values for the API endpoint and authentication.

## RELATED LINKS
