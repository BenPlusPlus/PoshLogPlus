function New-PLPLog {
    [CmdletBinding()]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNull()]
        [string]
        $FilePath,

        [Parameter(ParameterSetName='ParamSetOverwrite')]
        [switch]
        $Overwrite,

        [Parameter(ParameterSetName='ParamSetAppend')]
        [switch]
        $Append
    )

    Begin {}

    Process {
        if (Test-Path $FilePath -PathType Leaf) {
            if ($Overwrite) {
                Remove-Item -Path $FilePath -Force
            }
            elseif ($Append -eq $false) {
                Write-Error 'The specified file already exists. To overwrite or append to the existing file, use the -Overwrite or -Append parameters respectively.'
                return $null
            }
        }
        $obj = "" | select FilePath
        # Normalize the path since any relative elements could have weird side effects
        # during script execution (if Get-Location changes).
        #
        # Change the current working directory (to make sure it matches Get-Location).
        # This is necessary to ensure GetFullPath() returns the correct value. We'll
        # change it back afterward.
        $oldDir = [System.IO.Directory]::GetCurrentDirectory()
        [System.IO.Directory]::SetCurrentDirectory(((Get-Location -PSProvider FileSystem).ProviderPath))
        $obj.FilePath = [System.IO.Path]::GetFullPath($FilePath)
        [System.IO.Directory]::SetCurrentDirectory($oldDir)
        $obj
    }

    End {}
}


# Export this function
if( Test-Path Variable:EXPORTEDFUNCTIONS ) {
    $EXPORTEDFUNCTIONS += "$(( $MyInvocation.MyCommand.Name -replace '.ps1','' ).Trim())"
}

