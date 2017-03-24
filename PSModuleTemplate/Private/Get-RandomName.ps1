<#

#>

Function Get-RandomName {
	$PossibleNames = @(
		'Jeob'
		'Wedge'
		'Biggs'
		'Kirby'
		'Falcom'
		'2B'
		'Steve'
	)

	$RandInt = Get-Random -Minimum 0 -Maximum ($PossibleNames.Count + 1)
	Write-Output $PossibleNames[$RandInt]
}