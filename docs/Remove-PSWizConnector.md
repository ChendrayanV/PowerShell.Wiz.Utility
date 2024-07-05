---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version: https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
schema: 2.0.0
---

# Remove-PSWizConnector

## SYNOPSIS
Removes specified connectors from the Wiz platform.

## SYNTAX

```
Remove-PSWizConnector [-Id] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Remove-PSWizConnector function deletes connectors from the Wiz platform using their unique identifiers.
It sends a GraphQL request to the Wiz API to perform the deletion operation.

## EXAMPLES

### EXAMPLE 1
```
Remove-PSWizConnector -Id "12345"
This example removes the Wiz connector with the ID "12345".
```

### EXAMPLE 2
```
"12345","67890" | Remove-PSWizConnector
This example removes the Wiz connectors with the IDs "12345" and "67890".
```

## PARAMETERS

### -Id
Specifies the ID(s) of the connector(s) to be removed.
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

## OUTPUTS

### System.Object
### The function returns the result of the deletion operation. If there are errors, the function outputs the error messages; otherwise, it outputs the data related to the deleted connector.
## NOTES
The function constructs a GraphQL query from a local file named deleteConnector.graphql located in the .\graphql\ directory.
Authentication details ($Script:Access_Token and $Script:Data_Center) must be available in the script scope.
PowerShell 5.0 or higher is required.

## RELATED LINKS

[https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod](https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod)

