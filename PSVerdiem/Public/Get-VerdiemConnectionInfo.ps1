#
# Get_VerdiemStoredConnectionInfo.ps1
#

Function Get-VerdiemConnectionInfo {
[CmdletBinding()]
Param(
	[ValidateSet(
		"User",
		"Session"
	)]
	[String]$Scope = "User"

)

	If ($Scope -eq "Session") {
		If ($Script:Connection -eq $null) {
			throw "No stored connection information exists. Use Set-VerdiemConnectionInfo to store connection information."
		} Else {
			return $Script:Connection
		}
	} Elseif ($Scope -eq "User") {
		If (Test-Path "$env:APPDATA\PSVerdiem\ConnectionInfo.clixml") {
			return Import-Clixml "$env:APPDATA\PSVerdiem\ConnectionInfo.clixml"
		} Else {
			throw "No stored connection information exists. Use Set-VerdiemConnectionInfo to store connection information."
		}
	}
}