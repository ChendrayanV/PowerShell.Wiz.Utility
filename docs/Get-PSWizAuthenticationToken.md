---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version:
schema: 2.0.0
---

# Get-PSWizAuthenticationToken

## SYNOPSIS
Retrieves an authentication token from Wiz API using client credentials.

## SYNTAX

```
Get-PSWizAuthenticationToken [-ClientID] <Object> [-ClientSecret] <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-PSWizAuthenticationToken cmdlet sends a request to the Wiz authentication endpoint to retrieve an OAuth 2.0 access token.
The cmdlet requires a Client ID and Client Secret to authenticate and obtain the token.

## EXAMPLES

### EXAMPLE 1
```
Get-PSWizAuthenticationToken -ClientID $ENV:Wiz_Client_ID -ClientSecret $Env:Client_Secret
This example directly specifies the Client ID and Client Secret to retrieve an authentication token.
```

## PARAMETERS

### -ClientID
The Client ID for the Wiz application.

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

### -ClientSecret
The Client Secret for the Wiz application.

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

## NOTES
The retrieved access token is stored in the global variable $Access_Token.
The data center information extracted from the token is stored in the global variable $Data_Center.

## RELATED LINKS

[Specify a URI to a help page, this will show when Get-Help -Online is used.]()

