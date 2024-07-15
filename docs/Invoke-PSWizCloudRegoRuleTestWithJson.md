---
external help file: PowerShell.Wiz.Utility-help.xml
Module Name: PowerShell.Wiz.Utility
online version:
schema: 2.0.0
---

# Invoke-PSWizCloudRegoRuleTestWithJson

## SYNOPSIS
Invokes a PSWiz Cloud Rego rule test using the provided JSON configuration.

## SYNTAX

```
Invoke-PSWizCloudRegoRuleTestWithJson [-RegoRule] <Object> [-TFJson] <Object>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-PSWizCloudRegoRuleTestWithJson function sends a GraphQL query to the PSWiz API to run a Cloud Rego rule test.
It requires the Rego rule and the Terraform JSON configuration as input parameters.
The function constructs the query using a template file and sends it to the PSWiz API endpoint.

## EXAMPLES

### EXAMPLE 1
```
$regoRule = "my-rego-rule"
PS C:\> $tfJson = Get-Content -Path "C:\path\to\tf.json" -Raw
PS C:\> Invoke-PSWizCloudRegoRuleTestWithJson -RegoRule $regoRule -TFJson $tfJson
```

This command invokes the PSWiz Cloud Rego rule test using the specified Rego rule and Terraform JSON configuration.

### EXAMPLE 2
```
$regoRule = "another-rego-rule"
PS C:\> $tfJson = '{"resource": {"aws_instance": {"example": {"ami": "ami-123456", "instance_type": "t2.micro"}}}}'
PS C:\> Invoke-PSWizCloudRegoRuleTestWithJson -RegoRule $regoRule -TFJson $tfJson
```

This command invokes the PSWiz Cloud Rego rule test using the specified Rego rule and an inline Terraform JSON configuration.

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

### -RegoRule
The Rego rule to be tested.
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

### -TFJson
The Terraform JSON configuration to be tested against the Rego rule.
This parameter is mandatory.

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

## NOTES
The function requires a GraphQL query template file named 'invokeCloudRegoRuleTest.graphql' located in a 'graphql' subfolder of the script's directory.
It also requires that the script-level variables $Script:Data_Center and $Script:Access_Token be set with the appropriate values for the API endpoint and authentication.

## RELATED LINKS
