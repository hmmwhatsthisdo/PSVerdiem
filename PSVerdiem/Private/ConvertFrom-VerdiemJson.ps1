#
# Convert_VerdiemData.ps1
#

Function ConvertFrom-VerdiemJson {
[CmdletBinding()]
Param (
	[Parameter(
		Mandatory = $true,
		Position = 0,
		ValueFromPipeline = $true
	)]
	[string]$Data

	# We may need this if Verdiem does actually use XML somewhere
	<#
	[ValidateSet(
		"Xml",
		"Json"
	)]
	[string]$Format
	#>
)

	<#
		Verdiem returns typed JSON objects - that is, ones with a __type field. 
		
		.NET's JavascriptSerializer class (which ConvertFrom-Json appears to use) uses this field for resolving to a type, but it doesn't appear to work in PoSH (or at least I can't figure out how to get it to work).

		As a stop-gap (until I can figure out how to preserve types), we can shift the __type fields around using a naive string replacement while we import the JSON, then recursively change around the members afterwards.
	#>

	# First, look for any __type fields in the JSON string and replace them.
	$Data = $Data -creplace '"__type":','"__type__shifted":'

	# Next, perform the conversion.
	$Object = $Data | ConvertFrom-Json

	Function _RecursiveMemberRename {
	Param(
		$Object
	)

		If ($Object.'__type__shifted') {
			$Object | Add-Member -MemberType NoteProperty -Name '__type' -Value $Object.'__type__shifted'
			$Object.PSObject.Properties.Remove("__type__shifted")
			$Object | Get-Member -MemberType NoteProperty | % {
				$MemberName = $($_.Name)
				_RecursiveMemberRename ($Object.$MemberName)
			}
		}
	}

	return _RecursiveMemberRename $Object


}