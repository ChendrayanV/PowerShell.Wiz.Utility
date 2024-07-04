---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version: https://docs.wiz.io/cli-releases
schema: 2.0.0
---

# Get-PSWizConfigurationFinding

## SYNOPSIS
Retrieves configuration findings from a specified source with a given status.

## SYNTAX

```
Get-PSWizConfigurationFinding [-Status] <Object> [-Source] <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-PSWizConfigurationFinding cmdlet queries the Wiz API to retrieve configuration findings based on the specified status and source.
The findings are retrieved using a GraphQL query and are returned as a collection.

## EXAMPLES

### EXAMPLE 1
```
Get-PSWizConfigurationFinding -Status OPEN -Source WIZ_CSPM
This command retrieves all configuration findings with the status 'OPEN' from the source 'WIZ_CSPM'.
```

### EXAMPLE 2
```
Get-PSWizConfigurationFinding -Status RESOLVED -Source AWSInspector
This command retrieves all configuration findings with the status 'RESOLVED' from the source 'AWSInspector'.
```

## PARAMETERS

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

### -Source
Specifies the source of the configuration findings.
Valid values are:
    - WIZ_CSPM
    - ASC
    - AWSInspector

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Specifies the status of the configuration findings to retrieve.
Valid values are:
    - OPEN
    - IN_PROGRESS
    - RESOLVED
    - REJECTED

```yaml
Type: Object
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

### PSCustomObject
###     The function returns a collection of configuration findings based on the specified status and source.
## NOTES
Author : Chendrayan Venkatesan (Chen V)

## RELATED LINKS
