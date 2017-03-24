using module .\Classes\Something.psm1

#Load private & public functions
Try {
	'Public','Private' | ForEach-Object {
		Get-ChildItem "$PSScriptRoot\$_\" -Filter '*.ps1' | ForEach-Object {
			Write-Debug "DotSourcing: $($_.Name)"
			. $_.FullName
		}
   }
}
Catch {
   $PSCmdlet.ThrowTerminatingError($_)
}

#Export public functions
Get-ChildItem -Path "$PSScriptRoot\Public\" -Filter '*.ps1' | ForEach-Object {
	Export-ModuleMember -Function $_.BaseName
}