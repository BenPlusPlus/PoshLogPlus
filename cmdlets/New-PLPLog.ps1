<#
.SYNOPSIS
    Creates a log object for use with PoshLogPlus logging functions.
.DESCRIPTION
    This command will construct a log object that can be passed to
    other *-PLP functions for log writing. The log object holds
    certain properties of the resulting log file so that each PLP
    function knows how to treat that file.
.PARAMETER FilePath
    The full path and filename of the desired log file. The file
    cannot already exist unless either the -Overwrite or -Append
    switch is passed to this command.
.PARAMETER Overwrite
    If the specified file currently exists, delete it immediately
    in anticipation of the writing of a new log. Cannot be used
    simultaneously with the -Append parameter.
.PARAMETER Append
    If the specified file currently exists, preserve it and simply
    append further log messages to that file. Cannot be used
    simultaneously with the -Overwrite parameter.
.PARAMETER Encoding
    The character encoding of the resulting log file. Valid values
    are: 'Unicode','BigEndianUnicode','UTF8','UTF7','UTF32','ASCII',
    'Default','OEM'
.EXAMPLE
    $log = New-PLPLog -FilePath 'C:\Logs\MyScript.log'
.EXAMPLE
    $log = New-PLPLog -FilePath 'C:\Logs\MyScript.log' -Encoding 'Unicode' -Overwrite
.NOTES
    Created By : Ben Baird
.LINK
    https://github.com/BenPlusPlus/PoshLogPlus
#>
function New-PLPLog {
    [CmdletBinding()]
    [OutputType([PLPLog])]
    Param
    (
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNull()]
        [string]
        $FilePath,

        [switch]
        $Overwrite,

        [switch]
        $Append,

        [ValidateSet('Unicode','BigEndianUnicode','UTF8','UTF7','UTF32','ASCII','Default','OEM')]
        [string]
        $Encoding = 'Unicode'
    )

    Begin {}

    Process {
        # Validate switch combinations
        if ($Overwrite -and $Append) {
            Write-Error 'The -Overwrite and -Append parameters cannot be used together; they are mutually exclusive.'
            return $null
        }

        if (Test-Path $FilePath -PathType Leaf) {
            if ($Overwrite) {
                Remove-Item -Path $FilePath -Force
            }
            elseif ($Append -eq $false) {
                Write-Error 'The specified file already exists. To overwrite or append to the existing file, use the -Overwrite or -Append parameters respectively.'
                return $null
            }
        }
        $obj = New-Object PLPLog

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

        $obj.Encoding = $Encoding
        $obj
    }

    End {}
}


# Export this function
if( Test-Path Variable:EXPORTEDFUNCTIONS ) {
    $EXPORTEDFUNCTIONS += "$(( $MyInvocation.MyCommand.Name -replace '.ps1','' ).Trim())"
}

