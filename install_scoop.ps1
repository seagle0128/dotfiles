#############################################################
# Install and update scoop packages on Windows
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Packages
$packages = (
    # Prerequisites
    "git", "gitui", "gow", "gsudo", "less",

    # Utilities
    "7zip", "everything", "totalcommander", "starship",
    # "aspell", "clipx", "putty", "ccleaner", "fork",

    # Morden tools
    "bat", "bottom", "btop", "delta","duf", "dust", "eza", "fzf", "fd",
    "gping", "hyperfine", "procs", "tealdeer", "ripgrep", "zoxide",

    # Editor
    "emacs", # "emacs-kl", "vim",
    "vscode",

    # Screencast
    "licecap", "carnac",

    # Music
    # "mpc", "mpd", "foobar2000",

    # Misc
    # "go", "python", "ruby", "nodejs-lts",
    # "sysinternals", "dependecywalker",
    # "clash-verge-rev", "v2rayn"
);

function check {
    # check if scoop exists
    if (-Not (Get-Command 'scoop' -errorAction SilentlyContinue)) {
        Write-Host "`n-> Installing Scoop..."
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
        # Invoke-RestMethod get.scoop.sh | Invoke-Expression
        Invoke-WebRequest -useb scoop.201704.xyz | Invoke-Expression
        scoop config SCOOP_REPO 'https://gitee.com/glsnames/scoop-installer'
        scoop bucket add extras

        if (-Not (Test-Path $PROFILE)) {
            Copy-Item Microsoft.PowerShell_profile.ps1 $PROFILE

            # Prerequisit
            Install-Module -Name PSFzf
            Install-Module -Name ZLocation
            Install-Module -Name git-aliases
            Install-Module -Name Terminal-Icons -Repository PSGallery

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
