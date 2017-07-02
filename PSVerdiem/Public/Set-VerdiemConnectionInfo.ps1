#
# Set_VerdiemConnectionInfo.ps1
#

Function Set-VerdiemConnectionInfo {
[CmdletBinding()]
Param(
	
	[Parameter(
		Mandatory = $true,
		Position = 0,
		ValueFromPipeline = $true,
		ParameterSetName = "ByProperty"
	)]
	[psobject]$InputObject,

	[Parameter(
		Mandatory = $true,
		Position = 0,
		ValueFromPipelineByPropertyName = $true,
		ParameterSetName = "ByValue"
	)]
	[Alias(
		"ServerName",
		"Hostname",
		"host",
		"ComputerName",
		"cn"
	)]
	[ValidateNotNullOrEmpty()]
	[String]$Server,
	
	[Parameter(
		ValueFromPipelineByPropertyName = $true,
		ParameterSetName = "ByValue"
	)]
	[Switch]$Secure,

	[Parameter(
		Mandatory = $true,
		Position = 1,
		ValueFromPipelineByPropertyName = $true,
		ParameterSetName = "ByValue"
	)]
	[System.Management.Automation.CredentialAttribute()]
	[ValidateNotNullOrEmpty()]
	[pscredential]$Credential,

	[ValidateNotNullOrEmpty()]
	[ValidateSet(
		"Session",
		"User"
	)]
	[String]$Scope = "User"
)

	If ($PSCmdlet.ParameterSetName -eq "ByProperty") {
	
		$Server = $InputObject.Server
		$Secure = $InputObject.Secure
		$Credential = $InputObject.Credential

	}

	Write-Verbose "Storing credentials for $($Credential.UserName) and Verdiem server $Server..."

	$Script:Connection = @{
		Server = $Server
		Secure = $Secure
		Credential = $Credential
	}

	If ($Scope -eq "User") {
		Write-Verbose "Writing account information to disk..."
		New-Item -ItemType Directory -Path $env:APPDATA\PSVerdiem -Force | Out-Null
		$Script:Connection | Export-Clixml $env:APPDATA\PSVerdiem\ConnectionInfo.clixml
		Write-Verbose "Account information saved to $env:APPDATA\PSVerdiem\ConnectionInfo.clixml."
	}
		
}