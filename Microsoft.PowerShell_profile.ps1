# Copy to $PROFILE

# Prerequisites:
# scoop install psfzf
# scoop install starship

# Starship
Invoke-Expression (&starship init powershell)

# Autosuggest
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# example command - use $Location with a different command:
$commandOverride = [ScriptBlock] { param($Location) Write-Host $Location }
# pass your override to PSFzf:
Set-PsFzfOption -AltCCommand $commandOverride

# Replace Tab
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
