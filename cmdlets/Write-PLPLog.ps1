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

