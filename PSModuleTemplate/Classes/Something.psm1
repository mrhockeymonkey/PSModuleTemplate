<#
	.SYNOPSIS
	Something class

	.DESCRIPTION
	A class that describes the layout of something
#>

Class Something {
	[Int]$Id
	[String]$Name

	Something([Int]$Id, [String]$Name) {
		$this.Id = $Id
		$this.Name = $Name
	}
}