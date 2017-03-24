Function Get-Something {
    [CmdletBinding()]
    Param()

    1..5 | ForEach-Object {
        [Something]::New($_, "Something$_")
    }
}