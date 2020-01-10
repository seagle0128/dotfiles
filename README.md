# Centaur Dotfiles

![Centaur](logo.png)

Full and clean configurations for development environment on GNU Linux, macOS
and Cygwin.

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

## Docker

``` shell
cd ~/.dotfiles
docker build -t centaur/ubuntu .
docker run -it centaur/ubuntu zsh
```

## Shortcuts

- `Alt-c`: cd into the selected directory.
- `Ctrl-g`: Paste the recent path(s) fr{}om `z` history into the command line.
- `Ctrl-r`: Paste the selected command from history into the command line.
- `Ctrl-t`: Paste the selected file path(s) into the command line.

That's it. Enjoy!

## Customization

### ZSH ENV

Add your zsh environments in `~/.zshenv`. This is recommended by ZSH officially.
For example:

``` shell
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.rbenv/shims:$PATH
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
```

### ZSH local config

Set your personal zsh configurations in `~/.zshrc.local`. For example:

``` shell
# theme
antigen theme ys            # ys, dst, steeef, wedisagree, robbyrussell

# plugins
antigen bundle python
antigen bundle ruby
```

### Git local config

Set your git configurations in `~/.gitconfig.local`, e.g. user credentials.

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

## Screenshots

### Main (with Tmux)

![main](https://user-images.githubusercontent.com/140797/51855591-9717c880-2368-11e9-9270-bbadc3640982.png
"Main with tmux")

### Git Log

![git_log](https://user-images.githubusercontent.com/140797/51830877-cf4ce600-232b-11e9-9196-c35a59ebe491.png
" Git Log")

### [Centaur Emacs](https://github.com/seagle0128/.emacs.d)

![centaur_emacs](https://user-images.githubusercontent.com/140797/56488858-4e5c4f80-6512-11e9-9637-b9395c46400f.png
"Centaur Emacs")

## Acknowledgements

Related projects: [DevStrap](https://github.com/ray-g/devstrap)

## Donate

If you think the it's helpful for you, please consider paying a cup of coffee
for me. Thank you! :smile:

<img
src="https://user-images.githubusercontent.com/140797/65818854-44204900-e248-11e9-9cc5-3e6339587cd8.png"
alt="Alipay" width="120"/>
&nbsp;&nbsp;&nbsp;&nbsp;
<img
src="https://user-images.githubusercontent.com/140797/65818844-366ac380-e248-11e9-931c-4bd872d0566b.png"
alt="Wechat Pay" width="120"/>

<a href="https://paypal.me/seagle0128" target="_blank">
<img
src="https://www.paypalobjects.com/digitalassets/c/website/marketing/apac/C2/logos-buttons/optimize/44_Grey_PayPal_Pill_Button.png"
alt="PayPal" width="120" />
</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://www.buymeacoffee.com/s9giES1" target="_blank">
<img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee"
width="160"/>
</a>
