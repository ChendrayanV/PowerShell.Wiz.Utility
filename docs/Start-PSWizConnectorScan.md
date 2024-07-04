﻿---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version:
schema: 2.0.0
---

# Start-PSWizConnectorScan

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Start-PSWizConnectorScan [-ConnectorId] <String[]> [-OmitSecurityToolScan] <Boolean> [-OmitDataScan] <Boolean>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
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

### -ConnectorId
{{ Fill ConnectorId Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -OmitDataScan
{{ Fill OmitDataScan Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OmitSecurityToolScan
{{ Fill OmitSecurityToolScan Description }}

```yaml
Type: Boolean
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
###     The function returns the result of the scan initiation operation for each connector ID.
###     If there are errors, the function returns the error messages.
## NOTES

## RELATED LINKS