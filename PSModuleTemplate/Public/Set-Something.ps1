<#
	.SYNOPSIS
	Sets something

	.DESCRIPTION
	Use this function to set something

	.EXAMPLE
	Get-Something | Set-Somthing

	Job done!
#>

Function Set-Something {
    [CmdletBinding(
		SupportsShouldProcess = $true
	)]
    Param ()

    Begin {}

    Process {
		If ($PSCmdlet.ShouldProcess('Something')){
			#Set Something!
		}
	}

    End {}
}