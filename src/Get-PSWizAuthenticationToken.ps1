function Get-PSWizAuthenticationToken {
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
