
InModuleScope -ModuleName PSModuleTemplate {
	Describe 'PSModuleTemplate' {
		Context 'Pester' {
			It 'Pester tests should be invoked' {
				$true | Should Be $true
			}

			1..5 | ForEach-Object {
				It "$_ should be $_" {
					$_ | Should Be $_
				}
			}
		}
	}
}