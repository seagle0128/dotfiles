# Copy to $PROFILE

# Starship
Invoke-Expression (&starship init powershell)

# Readline
Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Fish-like Autosuggest
Set-PSReadLineOption -PredictionSource History

# FZF
# Replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# Replace Tab
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

Set-PsFzfOption -TabExpansion

# Aliases
Set-PsFzfOption -EnableAliasFuzzyEdit          # fe
Set-PsFzfOption -EnableAliasFuzzyHistory       # fh
Set-PsFzfOption -EnableAliasFuzzyKillProcess   # fkill
Set-PsFzfOption -EnableAliasFuzzyScoop         # fs
Set-PsFzfOption -EnableAliasFuzzyGitStatus     # fgs
Set-PsFzfOption -EnableAliasFuzzySetEverything # cde
Set-PsFzfOption -EnableAliasFuzzyZLocation     # fz
