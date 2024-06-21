# PowerShell.Wiz.Utility

## Overview

PowerShell.Wiz.Utility is a PowerShell module designed to facilitate interaction with Wiz tenants. This utility provides a collection of cmdlets that enable users to manage and retrieve various resources and configurations from Wiz.

## Disclaimer

**Note**: This version of PowerShell.Wiz.Utility does not include help documentation or automated testing. We are working on releasing comprehensive help documentation soon.

## Installation

To install PowerShell.Wiz.Utility, you can clone the repository and import the module into your PowerShell session:

```powershell
Install-Module -Name PowerShell.Wiz.Utility
```

## Cmdlets

Below is a list of available cmdlets in this module:

### Authentication
 
- **Get-PSWizAuthenticationToken.ps1**
  - Retrieves the authentication token for the connected Wiz tenant.

### Information Retrieval

- **Get-PSWizCLIRelease.ps1**
  - Retrieves the latest release information of the Wiz CLI.

- **Get-PSWizCloudConfigurationRule.ps1**
  - Retrieves cloud configuration rules from Wiz.

- **Get-PSWizConfigurationFinding.ps1**
  - Retrieves configuration findings from Wiz.

- **Get-PSWizDeployment.ps1**
  - Retrieves deployment information from Wiz.

- **Get-PSWizProject.ps1**
  - Retrieves project details from Wiz.

- **Get-PSWizSecurityFramework.ps1**
  - Retrieves security framework details from Wiz.

- **Get-PSWizSystemHealth.ps1**
  - Retrieves system health information from Wiz.

- **Get-WizVersion.ps1**
  - Retrieves the current version of the Wiz environment.

### Configuration Management

- **Remove-PSWizCloudConfigurationRule.ps1**
  - Removes a specified cloud configuration rule from Wiz.

## Usage

Here are some examples of how to use the cmdlets:

### Connect to Wiz Tenant

```powershell
Get-PSWizAuthenticationToken -ClientID $ENV:Wiz_CLIENT_ID -ClientSecret $ENV:Wiz_CLIENT_SECRET 
```

### Retrieve System Health

```powershell
Get-PSWizSystemHealth
```


### Remove a Cloud Configuration Rule

```powershell
Remove-PSWizCloudConfigurationRule -Id "rule-id"
```

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss potential changes.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

---

Stay tuned for updates and detailed help documentation in the upcoming releases!