function Get-PSWizAuthenticationToken {
    <#
    .SYNOPSIS
        Retrieves an authentication token from the Wiz platform.

    .DESCRIPTION
        The Get-PSWizAuthenticationToken function obtains an OAuth token from the Wiz platform's authentication service.
        It requires a client ID and client secret to generate the token. The token is then parsed and stored in script scope
        variables for use in subsequent API calls.

    .PARAMETER ClientID
        Specifies the client ID for authentication.
        This parameter is mandatory.

    .PARAMETER ClientSecret
        Specifies the client secret for authentication.
        This parameter is mandatory.

    .EXAMPLE
        Get-PSWizAuthenticationToken -ClientID "my-client-id" -ClientSecret "my-client-secret"
        This example retrieves an authentication token using the specified client ID and client secret.

    .OUTPUTS
        None
            The function sets the authentication token and data center information in script scope variables.

    .NOTES
        The function constructs an HTTP POST request to the Wiz authentication service to retrieve an OAuth token.
        The token is parsed to extract the data center information, which is also stored in a script scope variable.
        PowerShell 5.0 or higher is required.

    .LINK
        https://docs.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $ClientID,

        [Parameter(Mandatory)]
        $ClientSecret
    )
    $body = @{
        grant_type    = 'client_credentials'
        client_id     = $ClientID
        client_secret = $ClientSecret
        audience      = 'wiz-api'
    }
    try {
        $response = Invoke-RestMethod 'https://auth.app.wiz.io/oauth/token' -Method POST -ContentType 'application/x-www-form-urlencoded'  -Body $body 
        $access_token = $response.access_token
        $tokenPayload = $access_token.Split(".")[1].Replace('-', '+').Replace('_', '/')
        while ($tokenPayload.Length % 4) { Write-Verbose "Invalid length for a Base-64 char array or string, adding ="; $tokenPayload += "=" }
        $tokenByteArray = [System.Convert]::FromBase64String($tokenPayload)
        $tokenArray = [System.Text.Encoding]::ASCII.GetString($tokenByteArray)
        $tokobj = $tokenArray | ConvertFrom-Json
        $Script:Access_Token = $access_token
        $Script:Data_Center = $tokobj.dc
    }
    catch {
        Write-Error -Exception $_.Exception.Message -InformationAction Continue
    }

    
}
