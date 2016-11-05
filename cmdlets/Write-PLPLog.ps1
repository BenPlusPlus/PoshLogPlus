<#
.SYNOPSIS
    Writes a line to the specified log.
.DESCRIPTION
    This command writes the desired message to the specified log.
    The properties of the PLPLog object will determine how the
    message is written, and the format of the log. (See New-PLPLog
    for details on how to generate the PLPLog object.)
.PARAMETER Message
    A string containing the message to be written.
.PARAMETER LogFile
    The PLPLog object (optionally passed in through the pipeline)
    that points to the log to be updated.
.EXAMPLE
    $log | Write-PLPLog -Message 'A failure occurred.'
.EXAMPLE
    Write-PLPLog -Message 'A failure occurred.' -LogFile $log
.NOTES
    Created By : Ben Baird
.LINK
    https://github.com/BenPlusPlus/PoshLogPlus
#>
function Write-PLPLog {
    [CmdletBinding()]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(Mandatory, Position=1, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [PLPLog]
        $LogFile,

        [Parameter(Mandatory, Position=0)]
        [string]
        $Message
    )

    Begin {}

    Process {
        "$([DateTime]::Now.ToString('yyyy-MM-dd hh:mm:ss tt'))`t$Message" |
            Out-File -FilePath $($LogFile.FilePath) -Encoding $($LogFile.Encoding) -Append
    }

    End {}
}


# Export this function
if( Test-Path Variable:EXPORTEDFUNCTIONS ) {
    $EXPORTEDFUNCTIONS += "$(( $MyInvocation.MyCommand.Name -replace '.ps1','' ).Trim())"
}

