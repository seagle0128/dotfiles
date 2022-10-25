#############################################################
# Install and update scoop packages on Windows
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Packages
$packages = (
    # Prerequists
    "psfzf", "starship",

    # Utilities
    "7zip", "everything", "totalcommander",
    # "clipx", "putty"
    # "wox", "ccleaner", "fork",
    "git", "lazygit", "gow", "less",
    "bat", "fzf", "fd", "ripgrep", "ugrep",
    "aspell", "universal-ctags",

    # Editor
    "emacs", "vscode",

    # Screencast
    "licecap", "carnac",

    # Music
    "mpc", "mpd", "foobar2000",

    # Misc
    # "go", "python", "ruby", "nodejs-lts",
    # "sysinternals", "dependecywalker"
    "clash-mini"
);

function check {
    # check if scoop exists
    if (-Not (Get-Command 'scoop' -errorAction SilentlyContinue)) {
        Write-Host "`n-> Installing Scoop..."
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
        irm get.scoop.sh | iex
        scoop bucket add extras

        Install-Module -Name PSFzf
        Install-Module ZLocation -Scope CurrentUser

        if (-Not (Test-Path $PROFILE)) {
            cp Microsoft.PowerShell_profile.ps1 $PROFILE
        }
    }
}

function install {
    foreach ($p in $packages) {
        Write-Host "`n-> Installing $p..."
        scoop install ${p}
    }
}

function main {
    check
    install
}

main
