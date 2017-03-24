<#
	.SYNOPSIS

	.DESCRIPTION

#>

$Seperator = '------------------------------------------'
$RequiredModules = @('InvokeBuild', 'Pester', 'PSScriptAnalyzer')

Task . Init, Clean

Task Init {
	$Seperator

	#Import required modules
	$RequiredModules | ForEach-Object {
		If (-not (Get-Module -Name $_ -ListAvailable)){
			Try {
				Write-Output "Installing Module: $_"
				Install-Module -Name $_ -Force
			}
			Catch {
				Throw "Unable to install missing module - $($_.Exception.Message)"
			}
		}

		Write-Output "Importing Module: $_"
		Import-Module -Name $_
	}
}

Task Clean {
	Write-Output "Cleaning"
}