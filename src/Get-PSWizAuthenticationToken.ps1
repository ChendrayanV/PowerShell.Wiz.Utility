function Get-PSWizAuthenticationToken {
    <#
    .SYNOPSIS
        Retrieves an authentication token from Wiz API using client credentials.
    .DESCRIPTION
        The Get-PSWizAuthenticationToken cmdlet sends a request to the Wiz authentication endpoint to retrieve an OAuth 2.0 access token. The cmdlet requires a Client ID and Client Secret to authenticate and obtain the token.
    .PARAMETER ClientID
        The Client ID for the Wiz application.

    .PARAMETER ClientSecret
        The Client Secret for the Wiz application.
    .NOTES
        The retrieved access token is stored in the global variable $Access_Token.
        The data center information extracted from the token is stored in the global variable $Data_Center.
    .LINK
        Specify a URI to a help page, this will show when Get-Help -Online is used.
    .EXAMPLE
        Get-PSWizAuthenticationToken -ClientID $ENV:Wiz_Client_ID -ClientSecret $Env:Client_Secret
        This example directly specifies the Client ID and Client Secret to retrieve an authentication token.
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
