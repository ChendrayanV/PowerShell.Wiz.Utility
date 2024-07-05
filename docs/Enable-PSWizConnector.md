---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version:
schema: 2.0.0
---

# Enable-PSWizConnector

## SYNOPSIS
Enables specified connectors in the Wiz platform.

## SYNTAX

```
Enable-PSWizConnector [-Id] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Enable-PSWizConnector function enables connectors in the Wiz platform using their unique identifiers.
It sends a GraphQL request to the Wiz API to perform the enable operation.

## EXAMPLES

### EXAMPLE 1
```
Enable-PSWizConnector -Id "12345"
This example enables the Wiz connector with the ID "12345".
```

### EXAMPLE 2
```
"12345","67890" | Enable-PSWizConnector
This example enables the Wiz connectors with the IDs "12345" and "67890".
```

## PARAMETERS

### -Id
Specifies the ID(s) of the connector(s) to be enabled.
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
### Returns the result of the enable operation. If there are errors, they will be output; otherwise, the data related to the enabled connector will be output.
## NOTES
The function constructs a GraphQL query from a local file named enableConnector.graphql located in the .\graphql\ directory.
Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
PowerShell 5.0 or higher is required.

## RELATED LINKS

[Get-PSWizConnector
https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod]()

