# Centaur Dotfiles

![Centaur](logo.png)

Full and clean configurations for development environment on GNU Linux, macOS and Cygwin.

## Prerequisite

- GNU Linux, macOS, Cygwin
- git, zsh, curl/wget
- Recommend: GNU Emacs, tmux
- Optional: Vim

## Quickstart

Run this command in the console.

``` shell
sh -c "$(curl -fsSL https://github.com/seagle0128/dotfiles/raw/master/install.sh)"
```

or

``` shell
sh -c "$(wget https://github.com/seagle0128/dotfiles/raw/master/install.sh -O -)"
```

That's it. Enjoy!

# Customization

## ~/.zshenv

Add your zsh environments. This is recommended by ZSH officially. For example:

``` shell
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.rbenv/shims:$PATH
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
```

## ~/.zshrc.local

Your personal zsh configurations. For example:

``` shell
Please add your personal configurations here. -*- mode: sh -*-

# Set local aliases.
alias starwars="telnet towel.blinkenlights.nl"
```

## ~/.zshrc.theme.local

Set your favorite terminal theme. A fence one ~ys~ is set by default.

``` shell
ZSH_THEME="ys"                  # ys, dst, steeef, wedisagree
```

## ~/.gitconfig.local

Set your git configurations, e.g. user credentials.

``` shell
[commit]
    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/

    gpgsign = true

[user]
    name = John Doe
    email = john.doe@example.com
    signingkey = XXXXXXXX
```

# Screenshots

## Sample UI with Tmux
![tmux](https://github.com/ray-g/devstrap/raw/master/docs/snapshots/layout.PNG)

## Git Log
![git_log](https://github.com/ray-g/devstrap/raw/master/docs/snapshots/git_log.PNG)

# Acknowledgements

Related projects: [DevStrap](https://github.com/ray-g/devstrap)

# License

[MIT License](https://github.com/ray-g/devstrap/blob/master/LICENSE)
