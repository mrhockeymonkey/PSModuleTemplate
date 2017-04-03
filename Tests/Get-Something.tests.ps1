
Describe 'Get-Something' {
	Context 'Pester Tests' {
		1..5 | ForEach-Object {
			It "$_ should be $_" {
				$_ | Should Be $_
			}
		}
	}
}
