<#
	.SYNOPSIS
	Gets Something

	.DESCRIPTION
	Use this function to get something

	.EXAMPLE
	Get-Something

	Simple yet effective
#>

Function Get-Something {
    [CmdletBinding()]
    Param()

    1..5 | ForEach-Object {
        [Something]::New($_, "Something$_")
    }
}