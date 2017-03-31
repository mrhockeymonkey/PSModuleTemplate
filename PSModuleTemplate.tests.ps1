
InModuleScope -ModuleName PSModuleTemplate {
	Describe 'PSModuleTemplate' {
		Context 'Pester' {
			It 'Pester tests should be invoked' {
				$true | Should Be $true
			}
		}
	}
}