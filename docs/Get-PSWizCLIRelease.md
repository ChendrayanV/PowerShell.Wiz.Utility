---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version: https://docs.wiz.io/cli-releases
schema: 2.0.0
---

# Get-PSWizCLIRelease

## SYNOPSIS
Retrieves the latest CLI release information for the specified platform.

## SYNTAX

```
Get-PSWizCLIRelease [[-Platform] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-PSWizCLIRelease cmdlet sends a GraphQL query to the Wiz API to retrieve the latest CLI release information for a specified platform.
The available platforms include WINDOWS, LINUX, DARWIN, and DOCKER_LINUX.
The cmdlet uses a paging mechanism to ensure all release data is collected if multiple pages of results are returned.

## EXAMPLES

### EXAMPLE 1
```
Get-PSWizCLIRelease -Platform WINDOWS
This example retrieves the latest CLI release information for the Windows platform.
```

### EXAMPLE 2
```
Get-PSWizCLIRelease -Platform LINUX
This example retrieves the latest CLI release information for the Linux platform.
```

## PARAMETERS

### -Platform
Specifies the platform for which to retrieve the CLI release information.
Valid values are WINDOWS, LINUX, DARWIN, and DOCKER_LINUX.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
###     The function returns a collection of CLI release information based on the specified platform.
## NOTES
This function requires an active access token stored in the global variable $Access_Token and the data center information stored in the global variable $Data_Center.
The function reads a GraphQL query from a file named getCLIRelease.graphql located in the .\graphql\ directory.

## RELATED LINKS

[https://docs.wiz.io/cli-releases](https://docs.wiz.io/cli-releases)

