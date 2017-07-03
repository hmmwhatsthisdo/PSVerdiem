#
# ConvertFrom_TypedJson.ps1
#

Function ConvertFrom-TypedJson {
[CmdletBinding()]
Param(
	[Parameter(
		Mandatory = $true,
		ValueFromPipeline = $true,
		Position = 0
	)]
	[ValidateNotNullOrEmpty()]
	[String]$InputObject,

	[ValidateNotNull()]
	[System.Web.Script.Serialization.JavaScriptTypeResolver]$TypeResolver = [System.Web.Script.Serialization.SimpleTypeResolver]::new()
)

	$Serializer = [System.Web.Script.Serialization.JavaScriptSerializer]::new($resolver)

	$Serializer.MaxJsonLength = [int32]::MaxValue
	$Serializer.RecursionLimit = 102 # PoSH max depth + 2, according to PowerShell's github
	
	$Object = $Serializer.DeserializeObject($InputObject)

	return $Object

}