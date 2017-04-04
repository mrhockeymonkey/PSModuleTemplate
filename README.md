[![Build status](https://ci.appveyor.com/api/projects/status/pj3imihqu1rxqr03?svg=true)](https://ci.appveyor.com/project/mrhockeymonkey/psmoduletemplate)

# PSModuleTemplate

This is a template module setup with CI baked in. The purpose of this repo is to record my preferences and also to use
as a base when developing module. 

### Key Features
* All module source code is contained in a folder not in the root
* InvokeBuild is used to create a single psm1 file and copy/update any other source files
* PSScriptAnalyzer settings are stored in a seperate file for easy configuration
* VSCode workspace settings are committed to keep contributers working in the same manner
* appveyor.yml is used to automatically compile,analyze and test any commits (Logically AppVeyor would also deploy but this is just a template)

### Key Benefits
* Can be run locally or integrate with CI engines like AppVeyor or Bamboo (My Experience so far)
* All source code is seperated for easy management
* When deploying, ONLY the files that are required are used. End users dont need pester tests, build scripts and other source
* By having all code in a single psm1 the module will load much faster (MUCH FASTER!)

### Room for improvements
* Using localised data for messages to seperate logic from text
* Generating help xmls and about files
* Format files
* Deployment


## Building 

### Locally 
You need only ```Invoke-Build```. Build script assumes local and BuildNumber 0 for local testing

### AppVeyor
All settings are defined in appveyor.yml. AppVeyor will automatically increment the build number and pass this into the build script

### Bamboo
Setup a powershell script task like below
```
Invoke-Build -CIEngine Bamboo -BuildNumber {bamboo.buildNumber}
```
