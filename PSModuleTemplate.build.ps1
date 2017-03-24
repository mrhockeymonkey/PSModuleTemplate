<#
	.SYNOPSIS

	.DESCRIPTION

#>

$ModuleName = 'PSModuleTemplate'
$Seperator = '------------------------------------------'
$RequiredModules = @('InvokeBuild', 'Pester', 'PSScriptAnalyzer')
$SourcePath = "$PSScriptRoot\$ModuleName"
$OutputPath = "$env:ProgramFiles\WindowsPowerShell\Modules"

Task . Init, Clean, Build

Task Init {
	$Seperator

	$Source = Get-Item -Path $SourcePath

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
	$Seperator
	Write-Output "Cleaning Output Path"
	Join-Path -Path $OutputPath -ChildPath $ModuleName | Get-Item -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force

}

Task Build {
	$Seperator
	
	#Create output module folder
	New-Item -Path $OutputPath -Name $ModuleName -ItemType Directory -OutVariable ModuleFolder

	#Create root module psm1 file
	$ModuleContentParts = 'Classes', 'Private', 'Public' | ForEach-Object {
		Join-Path -Path $SourcePath -ChildPath $_ | Get-ChildItem -Recurse -Depth 1 -Include '*.ps1','*.psm1' | Get-Content -Raw
	}
	$ModuleContent = $ModuleContentParts -join "`r`n`r`n`r`n"
	New-Item -Path $ModuleFolder.FullName -Name "$ModuleName.psm1" -ItemType File -Value $ModuleContent -OutVariable RootModule

	#Copy module manifest and any other source files
	Get-ChildItem -Path $SourcePath -File | Where-Object {$_.Name -ne $RootModule.Name} | Copy-Item -Destination $ModuleFolder.FullName

	#Update module manifest
	$ManifestFile = Join-Path -Path $ModuleFolder -ChildPath "$($RootModule.BaseName).psd1"
	$FunctionstoExport = Get-ChildItem -Path "$SourcePath\Public" -Filter '*.ps1' | Select-Object -ExpandProperty BaseName
	Update-ModuleManifest -Path $ManifestFile -FunctionsToExport $FunctionstoExport
}