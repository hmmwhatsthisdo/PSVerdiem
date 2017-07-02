# Get all of the pub/priv scripts 
$Script:Public = Get-ChildItem "$PSScriptRoot\Public\*.ps1" -ErrorAction SilentlyContinue
$Script:Private = Get-ChildItem "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue

# Import them
foreach ($Type in "Public","Private") {
	Write-Verbose "Importing $Type functions..."
	foreach ($ImportScript in (Get-Variable $Type -Scope Script -ValueOnly)) {
		Write-Verbose "Importing function $($Import.Basename)..."
		try {
			. $Import.FullName
		} 
		catch {
			Write-Error "Failed to import $type function $($import.BaseName): $_"
		}
		
	}
}

# Export our public functions, now that they exist
$Script:Public | Foreach-Object BaseName | Export-ModuleMember

# Now, get stored connection information if it's available
$Script:Connection = Get-VerdiemStoredConnectionInfo