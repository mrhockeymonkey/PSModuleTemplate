<#
	.SYNOPSIS
	InvokeBuild Script to Build, Analyze & Test Module

	.DESCRIPTION
	This script will be consume by InvokeBuild module and carry out each defined task
#>

Param (
	[Int]$BuildNumber,
	
	[ValidateSet('Bamboo','AppVeyor')]
	[String]$CIEngine
)

$ModuleName = 'PSModuleTemplate'
$Seperator = '------------------------------------------'
$RequiredModules = @('InvokeBuild', 'Pester', 'PSScriptAnalyzer')
$SourcePath = "$PSScriptRoot\$ModuleName"
$OutputPath = "$env:ProgramFiles\WindowsPowerShell\Modules"

Task . Init, Clean, Build, Analyze, Test

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
	$Path = Join-Path -Path $OutputPath -ChildPath $ModuleName
	Write-Output "Cleaning: $Path"
	$Path | Get-Item -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force

}

Task Build {
	$Seperator
	
	#Create output module folder
	Write-Output "Building Module..."
	$Script:ModuleFolder = New-Item -Path $OutputPath -Name $ModuleName -ItemType Directory

	#Create root module psm1 file
	$ModuleContentParts = 'Classes', 'Private', 'Public' | ForEach-Object {
		Join-Path -Path $SourcePath -ChildPath $_ | Get-ChildItem -Recurse -Depth 1 -Include '*.ps1','*.psm1' | Get-Content -Raw
	}
	$ModuleContent = $ModuleContentParts -join "`r`n`r`n`r`n"
	$RootModule = New-Item -Path $ModuleFolder.FullName -Name "$ModuleName.psm1" -ItemType File -Value $ModuleContent

	#Copy module manifest and any other source files
	Write-Output "Copying other source files..."
	Get-ChildItem -Path $SourcePath -File | Where-Object {$_.Name -ne $RootModule.Name} | Copy-Item -Destination $ModuleFolder.FullName

	#Update module manifest
	Write-Output "Updating module manifest..."
	$ManifestPath = Join-Path -Path $ModuleFolder -ChildPath "$($RootModule.BaseName).psd1"
	
	If ($BuildNumber) {
		$Version = Test-ModuleManifest -Path $ManifestPath | Select-Object -ExpandProperty Version
		$Version = [Version]::New($Version.Major, $Version.Minor, $BuildNumber)
		Write-Host "Updating Manifest ModuleVersion to $Version"
		Update-ModuleManifest -Path $ManifestPath -ModuleVersion $Version
	}

	$FunctionstoExport = Get-ChildItem -Path "$SourcePath\Public" -Filter '*.ps1' | Select-Object -ExpandProperty BaseName
	Write-Output "Updating Manifest FunctionsToExport to $FunctionstoExport"
	Update-ModuleManifest -Path $ManifestPath -FunctionsToExport $FunctionstoExport
}

Task Analyze {
	$Seperator
	Write-Output "Running script analyzer..."
	
	$AnalyzerIssues = Invoke-ScriptAnalyzer -Path $ModuleFolder -Settings "$PSScriptRoot\ScriptAnalyzerSettings.psd1"

	If ($AnalyzerIssues) {
		Write-Warning "PSScriptAnalyzer has found the following issues:"
		$AnalyzerIssues
		Throw "Script analyzer returned issues!"
	}
	Else {
		Write-Output "No issues found"
	}
}

Task Test {
	$Seperator
	Write-Output "Running pester tests..."

	$NUnitXml = 'PesterOutput.xml'
	Import-Module -Name $ModuleName
	$TestResults = Invoke-Pester -Path $PSScriptRoot -PassThru -OutputFormat NUnitXml -OutputFile "$PSScriptRoot\$NUnitXml"

	#Upload tests to appveyor
	If ($CIEngine -eq 'AppVeyor') {
		Write-Output "Uploading test results to appveyor..."
		$WebClient = New-Object 'System.Net.WebClient'
		$WebClient.UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)","$ProjectRoot\$NUnitXml" )

		# upload results to AppVeyor
$wc = New-Object 'System.Net.WebClient'
$wc.UploadFile("https://ci.appveyor.com/api/testresults/xunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path .\xunit-results.xml))
	}

	If ($TestResults.FailedCount -gt 0) {
		Throw "Failed $($TestResults.FailedCount) test(s)!"
	}
}