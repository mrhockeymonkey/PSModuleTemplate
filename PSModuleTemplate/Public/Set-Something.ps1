Function Set-Something {
    [CmdletBinding(
		SupportsShouldProcess = $true
	)]
    Param ()

    Begin {}

    Process {
		If ($PSCmdlet.ShouldProcess('Something')){
			#Set Something
		}
	}

    End {}
}