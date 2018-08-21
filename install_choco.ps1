#############################################################
# Install and update chocolatey packages on Windows
# Author: Vincent Zhang <seagle0128@gmail.com>
# URL: https://github.com/seagle0128/dotfiles
#############################################################

# Packages
$packages = (
    "chocholatey",
    "7zip", "clipx", "everything", "putty",
    "emacs", "vscode",
    "totalcommander", "wox", "ccleaner",
    "googlechrome", # "firefox",
    "git", "tortoisegit",
    "peco", "ag", "pt", "ripgrep",
    # "cygwin", "cyg-get",
    # "golang", "python", "ruby", "nodejs",
    # "jdk8", "jre8", "eclipse",
    "sysinternals", "dependecywalker"
);

function Test-Administrator
{
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function check {
    # check admin rights
    if (-Not (Test-Administrator)) {
        Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
        exit 1
    }

    # check if choco exists
    if (-Not (Get-Command 'choco' -errorAction SilentlyContinue)) {
        Write-Host "`n-> Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
}

function install {
    foreach($p in $packages){
        Write-Host "`n-> Installing $p..."
        choco upgrade ${p} -y
    }

    RefreshEnv
}

function main {
    check
    install
}

main
