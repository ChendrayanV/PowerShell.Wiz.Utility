---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version:
schema: 2.0.0
---

# Disable-PSWizConnector

## SYNOPSIS
Disables specified connectors in the Wiz platform.

## SYNTAX

```
Disable-PSWizConnector [-Id] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Disable-PSWizConnector function disables connectors in the Wiz platform using their unique identifiers.
It sends a GraphQL request to the Wiz API to perform the disable operation.

## EXAMPLES

### EXAMPLE 1
```
Disable-PSWizConnector -Id "12345"
This example disables the Wiz connector with the ID "12345".
```

### EXAMPLE 2
```
"12345","67890" | Disable-PSWizConnector
This example disables the Wiz connectors with the IDs "12345" and "67890".
```

## PARAMETERS

### -Id
Specifies the ID(s) of the connector(s) to be disabled.
This parameter is mandatory and accepts an array of strings.
The IDs can be retrieved by using the Get-PSWizConnector cmdlet.

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

### String[]
### You can pipe an array of strings representing the connector IDs to this cmdlet.
## OUTPUTS

### System.Object
### Returns the result of the disable operation. If there are errors, they will be output; otherwise, the data related to the disabled connector will be output.
## NOTES
The function constructs a GraphQL query from a local file named disableConnector.graphql located in the .\graphql\ directory.
Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
PowerShell 5.0 or higher is required.

## RELATED LINKS

[Get-PSWizConnector
https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod]()

