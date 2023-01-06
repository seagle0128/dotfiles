#############################################################
# Install and update scoop packages on Windows
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Packages
$packages = (
    # Utilities
    "7zip", "everything", "totalcommander",
    # "clipx", "putty", "ccleaner", "fork",
    "git", "lazygit", "gow", "gsudo", "less",
    "aspell", "universal-ctags",

    "bat", "fzf", "fd", "ripgrep", "ugrep",
    "btop", "dust", "gping", "tealdeer",

    # Editor
    "emacs", "vscode",

    # Screencast
    "licecap", "carnac",

    # Music
    "mpc", "mpd", "foobar2000",

    # Misc
    # "go", "python", "ruby", "nodejs-lts",
    # "sysinternals", "dependecywalker"
    # "clash-mini"
);

function check {
    # check if scoop exists
    if (-Not (Get-Command 'scoop' -errorAction SilentlyContinue)) {
        Write-Host "`n-> Installing Scoop..."
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
        scoop bucket add extras

        if (-Not (Test-Path $PROFILE)) {
            Copy-Item Microsoft.PowerShell_profile.ps1 $PROFILE

            # Prerequisit
            scoop install starship
            Install-Module -Name PSFzf
            Install-Module -Name ZLocation

            # Reload
            . $PROFILE
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
