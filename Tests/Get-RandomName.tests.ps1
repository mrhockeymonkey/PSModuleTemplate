#In module scope is needed becuase this function is not exported
InModuleScope -ModuleName PSModuleTemplate {
	Describe 'Get-RandomName' {
		Context 'Pester Tests' {
			1..5 | ForEach-Object {
				It "$_ should be $_" {
					$_ | Should Be $_
				}
			}
		}
	}
}