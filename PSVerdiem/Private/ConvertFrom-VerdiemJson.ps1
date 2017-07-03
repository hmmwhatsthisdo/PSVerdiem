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

	# Next, perform the conversion to JSON.
	$Object = $Data | ConvertFrom-Json

	# Recursively switch shifted __type fields back to their original names.
	Function _RecursiveMemberRename {
	Param(
		$Object
	)
		# If the object has a type...
		If ($Object.'__type__shifted') {

			# Add a NoteProperty member with the original name/value.
			$Object | Add-Member -MemberType NoteProperty -Name '__type' -Value $Object.'__type__shifted'

			# Remove the old property.
			$Object.PSObject.Properties.Remove("__type__shifted")

			# Iterate over all NoteProperty members in this object (as the existence of the __type field indicates it was a container object)
			$Object | Get-Member -MemberType NoteProperty | % {
				$MemberName = $($_.Name)
				
				# Recurse onto those members.
				_RecursiveMemberRename ($Object.$MemberName)
			}
		}
	}

	_RecursiveMemberRename $Object

	return $Object


}