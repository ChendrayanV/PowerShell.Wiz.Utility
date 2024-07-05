---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version: https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
schema: 2.0.0
---

# New-PSWizConnector

## SYNOPSIS
Creates a new connector in the Wiz platform using the provided parameters.

## SYNTAX

```
New-PSWizConnector [-Name] <Object> [-Type] <Object> [-SubscriptionId] <Object> [-TenantId] <Object>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-PSWizConnector function constructs a GraphQL query using the provided parameters
and sends a request to the Wiz API to create a new connector.
This function is specifically
designed to create Azure connectors in the Wiz platform.

## EXAMPLES

### EXAMPLE 1
```
New-PSWizConnector -Name "MyConnector" -Type "azure" -Enabled "true" -IsManagedIdentity "true" `
                -SubscriptionId "12345678-1234-1234-1234-123456789012" -TenantId "87654321-4321-4321-4321-210987654321"
This example creates a new Azure connector named "MyConnector" that is enabled and uses managed identity.
```

## PARAMETERS

### -Name
Specifies the name of the connector to be created.
This parameter is mandatory.

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

### -SubscriptionId
Specifies the Azure subscription ID associated with the connector.
This parameter is mandatory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TenantId
Specifies the Azure tenant ID associated with the connector.
This parameter is mandatory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Specifies the type of the connector.
The only supported value is 'azure'.
This parameter is mandatory.
Valid values: 'azure'

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
###     The function returns the details of the created connector.
###     If there are errors, the function returns the error messages.
## NOTES
The function reads the GraphQL query template from a local file named createConnector.graphql located in the .\graphql\ directory.
The function requires authentication details ($Script:Access_Token and $Script:Data_Center) to be available in the script scope.
PowerShell 5.0 or higher is required.

## RELATED LINKS

[https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod](https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod)

