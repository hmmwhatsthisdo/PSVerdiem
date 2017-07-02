Function Invoke-VerdiemWebRequest {
[CmdletBinding()]
Param(
    [Parameter(
        Mandatory=$true,
        Position=0
    )]
    [ValidateNotNullOrEmpty()]
    [String]$Server,

    [Switch]$Secure,

    [ValidateNotNullOrEmpty()]
    [System.Management.Automation.CredentialAttribute()]
    [pscredential]$Credential, # = (Get-VerdiemLastCredential -Server $Server),

    [String]$ServicePath = "Admin",

    [String]$ServiceName = "AdminService.svc",

    [String]$MethodName,


    [Object]$Body,

    [Switch]$Raw
)

    # Set-VerdiemLastCredential -Server $Server -Credential $Credential -Secure $Secure

    $Endpoint = ((&{If ($secure) {"https"} Else {"http"}}) + "://" + $Server)

    $Params = @{
        Uri = "$Endpoint/$ServicePath/$ServiceName/$MethodName"
        Method = "Post"
        Credential = $Credential
        Body = ($Body | ConvertTo-Json -Depth 100 -Compress)
        ContentType = "application/json"
    }

    If ($Raw) {
        return Invoke-WebRequest @params | % Content
    } Else {
        return Invoke-RestMethod @params
    }

    
    
}