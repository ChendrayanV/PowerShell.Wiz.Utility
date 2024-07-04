---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version: https://docs.wiz.io/cli-releases
schema: 2.0.0
---

# Get-PSWizDeployment

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### All
```
Get-PSWizDeployment [-All] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Status
```
Get-PSWizDeployment [-Status <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -All
Shows all deployment

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
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

### -Status
Shows Enabled or Disabled status of the deployment

```yaml
Type: Object
Parameter Sets: Status
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
###     The function returns a collection of deployments.
###     If the All parameter is specified, all deployments are returned.
###     If the Status parameter is specified, deployments are filtered based on the provided status.
## NOTES

## RELATED LINKS
