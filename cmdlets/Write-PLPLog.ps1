function Write-PLPLog {
    [CmdletBinding()]
    [OutputType([PSObject])]
    Param
    (
        [Parameter(Mandatory, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [PSObject]
        $LogFile,

        [Parameter(Mandatory, Position=1)]
        [string]
        $Message
    )

    Begin {}

    Process {
        "$([DateTime]::Now.ToString('yyyy-MM-dd hh:mm:ss ap'))`t$Message" | Out-File -FilePath $($LogFile.FilePath) -Append
    }

    End {}
}


# Export this function
if( Test-Path Variable:EXPORTEDFUNCTIONS ) {
    $EXPORTEDFUNCTIONS += "$(( $MyInvocation.MyCommand.Name -replace '.ps1','' ).Trim())"
}

