#
# New_VerdiemFilter.ps1
#
Function New-VerdiemFilter {
[CmdletBinding(
    DefaultParameterSetName = "Attribute"
)]
Param (

#region Attribute Set "Attribute"
	[Parameter(
		Mandatory = $true,
		Position = 0,
		ParameterSetName = "Attribute"
	)]
	[String]$AttributeName,

	[Parameter(
		Mandatory = $true,
		Position = 1,
		ParameterSetName = "Attribute"
	)]
	[ValidateSet(
		"Contains"
	)]
	[String]$CompareOperator,

	[Parameter(
		Mandatory = $true,
		Position = 2,
		ParameterSetName = "Attribute"
	)]
	[ValidateNotNullOrEmpty()]
	[String]$Value,
#endregion

#region Attribute Set "Compound_Unary"
	[Parameter(
		Mandatory = $true,
		Position = 0,
		ParameterSetName = "Compound_Unary"
	)]
	[ValidateCount(
		2, 
		([int32]::MaxValue)
	)]
	[PSVerdiem.AbstractDeviceFilter[]]$Filters,

#endregion

#region Attribute Set "Compound_Binary"
	[Parameter(
		Mandatory = $true,
		Position = 0,
		ParameterSetName = "Compound_Binary"
	)]
	[PSVerdiem.AbstractDeviceFilter[]]$Left,

	[Parameter(
		Mandatory = $true,
		Position = 2,
		ParameterSetName = "Compound_Binary"
	)]
	[PSVerdiem.AbstractDeviceFilter[]]$Right,

#endregion

	[Parameter(
		Mandatory = $true,
		Position = 1,
		ParameterSetName = "Compound_Unary"
	)]
	[Parameter(
		Mandatory = $true,
		Position = 1,
		ParameterSetName = "Compound_Binary"
	)]
	[ValidateSet(
		"And",
		"Or"
	)]
	[String]$JoinOperator,

	[Parameter(
		ParameterSetName = "Compound_Unary"
	)]
	[Parameter(
		ParameterSetName = "Compound_Binary"
	)]
	[Switch]$SkipOptimize

)

Process {
	Switch -Wildcard ($PSCmdlet.ParameterSetName) {
		"Attribute" {
			return [PSVerdiem.attributeDeviceFilter]::new($Value, $CompareOperator, $AttributeName)
			Continue
		}

		"Compound_Unary" {
			If (-not $SkipOptimize) {
				$NewFilters = @()
				$NewFilters += $Filters | ? {$_ -is [PSVerdiem.attributeDeviceFilter]}
				$NewFilters += $Filters | ? {$_ -is [PSVerdiem.compoundDeviceFilter]} | ? Operator -NE $JoinOperator
				$NewFilters += $Filters | ? {$_ -is [PSVerdiem.compoundDeviceFilter]} | ? Operator -EQ $JoinOperator | % Filters

			} Else {
                $NewFilters = $Filters
            }
		}

		"Compound_Binary" {

			$NewFilters = @()

			If ($SkipOptimize) {
				$NewFilters += $Left
				$NewFilters += $Right | Out-Null
			} Else {

				# Flatten the left and right sides into single filter objects.

				If ($Left.Count -gt 1) {
					$Left = New-VerdiemFilter -Filters $Left -JoinOperator $JoinOperator
				}

				If ($Right.Count -gt 1) {
					$Right = New-VerdiemFilter -Filters $Right -JoinOperator $JoinOperator
				}

				If ($Left[0] -is [PSVerdiem.compoundDeviceFilter] -and ($Left.Operator -eq $JoinOperator)) {
					$NewFilters += $Left.Filters
				} Else {
					$NewFilters += $Left
				}
				
				If ($Right[0] -is [PSVerdiem.compoundDeviceFilter] -and ($Right.Operator -eq $JoinOperator)) {
					$NewFilters += $Right.Filters
				} Else {
					$NewFilters += $Right
				}



			}
		}

		"Compound_*" {			
			return [PSVerdiem.compoundDeviceFilter]::new([PSVerdiem.AbstractDeviceFilter[]]$NewFilters, $JoinOperator)
			Continue
		}
	}

}


}