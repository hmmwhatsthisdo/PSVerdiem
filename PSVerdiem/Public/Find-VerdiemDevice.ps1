#
# Find_VerdiemDevice.ps1
#

Function Find-VerdiemDevice {
[CmdletBinding(
	DefaultParameterSetName="StringQuery"
)]
Param(
	[Parameter(
		ParameterSetName="StringQuery",
		Mandatory = $true
	)]
	[String]$StrinqQuery,

	[Parameter(
		ParameterSetName="NameOnlyQuery",
		Mandatory = $true,
		Position = 0
	)]
	[String]$Name,

	[Parameter(
		ParameterSetName="CustomFilterQuery",
		Mandatory = $true,
		Position = 0
	)]
	[PSVerdiem.AbstractDeviceFilter]$FilterObject
)

	switch ($PSCmdlet.ParameterSetName) {
		"StringQuery" {
				
		}
		"NameOnlyQuery" {
			
		}
		"CustomFilterQuery" {
		
		}
	}

}