# Copy to $PROFILE

Set-Variable DOTFILES "$env:APPDATA\.dotfiles"
Set-Variable EMACSD "$env:APPDATA\.emacs.d"
Set-Variable EDITOR 'emacsclientw -a ""'

#
# Functions
#
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

#
# Aliases
#
# Emacs
Set-Alias -Name me  -Value Open-Mini-Emacs
Set-Alias -Name mte -Value Open-Mini-Terminal-Emacs
Set-Alias -Name e   -Value Open-Emacs-Client-Nowait
Set-Alias -Name ec  -Value Open-Emacs-Client-Frame-Nowait
Set-Alias -Name ef  -Value Open-Emacs-Client-Frame
Set-Alias -Name te  -Value Open-Terminal-Emacs

# Utilities
Set-Alias -Name cat  -Value bat
Set-Alias -Name du   -Value dust
Set-Alias -Name ping -Value gping
Set-Alias -Name top  -Value btop

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