# PowerShell user profile
# Copy to $PROFILE to enable:
#   cp Microsoft.PowerShell_profile.ps1 $PROFILE

Set-Variable DOTFILES "$env:APPDATA\.dotfiles"
Set-Variable EMACSD "$env:APPDATA\.emacs.d"
Set-Variable EDITOR 'emacsclientw -a ""'

#
# Functions
#
function Update-Scoop-All {
    Invoke-Expression 'scoop update --all && scoop cleanup --all'
}

function Open-Mini-Emacs {
    Invoke-Expression 'runemacs -Q -l "$EMACSD\init-mini.el"'
}

function Open-Mini-Terminal-Emacs {
    Invoke-Expression 'emacs -Q -nw -l "$EMACSD\init-mini.el"'
}

function Open-Emacs-Client-Nowait {
    param ([string]$FileName)
    Invoke-Expression 'emacsclientw -a "" -n $FileName'
}

function Open-Emacs-Client-Frame-Nowait {
    param ([string]$FileName)
    Invoke-Expression 'emacsclientw -a "" -n -c $FileName'
}

function Open-Emacs-Client-Frame {
    param ([string]$FileName)
    Invoke-Expression 'emacsclientw -a "" -c $FileName'
}

function Open-Terminal-Emacs {
    param ([string]$FileName)
    Invoke-Expression 'emacs -Q -nw $FileName'
}

function Enable-Http-Proxy {
    $Env:http_proxy="http://127.0.0.1:7890";$Env:https_proxy="http://127.0.0.1:7890"
}

function Disable-Http-Proxy {
    $Env:http_proxy="";$Env:https_proxy=""
}

#
# Aliases
#
Set-Alias -Name sua -Value Update-Scoop-All

# Emacs
Set-Alias -Name me  -Value Open-Mini-Emacs
Set-Alias -Name mte -Value Open-Mini-Terminal-Emacs
Set-Alias -Name e   -Value Open-Emacs-Client-Nowait
Set-Alias -Name ec  -Value Open-Emacs-Client-Frame-Nowait
Set-Alias -Name ef  -Value Open-Emacs-Client-Frame
Set-Alias -Name te  -Value Open-Terminal-Emacs

# Utilities
Remove-Alias diff -Force
Set-Alias -Name cat  -Value bat # Use the latest less or --paging=never
Set-Alias -Name du   -Value dust
Set-Alias -Name ping -Value gping
Set-Alias -Name top  -Value btop

# Git
Import-Module git-aliases -DisableNameChecking

# Icons
Import-Module -Name Terminal-Icons

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

# Options
Set-PsFzfOption -EnableAliasFuzzyEdit          # fe
Set-PsFzfOption -EnableAliasFuzzyHistory       # fh
Set-PsFzfOption -EnableAliasFuzzyKillProcess   # fkill
Set-PsFzfOption -EnableAliasFuzzyScoop         # fs
Set-PsFzfOption -EnableAliasFuzzyGitStatus     # fgs
Set-PsFzfOption -EnableAliasFuzzySetEverything # cde
Set-PsFzfOption -EnableAliasFuzzyZLocation     # fz
