# Get all of the pub/priv scripts 
$Scripts = @{
	Public = Get-ChildItem "$PSScriptRoot\Public\*.ps1" -ErrorAction SilentlyContinue
	Private = Get-ChildItem "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue
}

# Import them
foreach ($Type in @("Public","Private")) {
	Write-Verbose "Importing $Type functions..."
	foreach ($ImportScript in $Scripts.$Type) {
		Write-Verbose "Importing function $($ImportScript.Basename)..."
		try {
			. $ImportScript.FullName
		} 
		catch {
			Write-Error "Failed to import $type function $($ImportScript.BaseName): $_"
		}
		
	}
}

# Create a TypeResolver for Verdiem JSON types
$Script:JSONTypeResolver = [PSVerdiem.StatefulTypeResolver]::new()

# Export our public functions, now that they exist
$Scripts.Public | ForEach-Object BaseName | Export-ModuleMember

# Now, get stored connection information if it's available
try {
	Get-VerdiemConnectionInfo -Scope User | Set-VerdiemConnectionInfo -Scope Session
} catch {
	Write-Warning "Unable to set default connection information. Use Set-VerdiemConnectionInfo to specify a server name and user credentials."
}
