# Preserve this folder name for use by any other child scripts that might need it.
$PSModuleRoot = $PSScriptRoot

# Child scripts will append to this array if they need to be exported.
$EXPORTEDFUNCTIONS = @()

# Bring in the cmdlets!
Get-ChildItem -Path "$PSModuleRoot\cmdlets" -Filter '*.ps1' |
Select-Object -ExpandProperty FullName |
ForEach-Object { . "$_" }

Export-ModuleMember -Function $EXPORTEDFUNCTIONS

