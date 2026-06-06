# Centaur Dotfiles

![Centaur](logo.png)

Full and clean configurations for development environment on GNU Linux and macOS.

## 🏗️ Project Structure

```
dotfiles/
├── config/              # Configuration files
│   ├── .gemrc           # Ruby gem configuration
│   ├── .gitconfig_*     # Platform-specific git configs
│   ├── .gitconfig_global # Global git configuration
│   ├── .gitignore_global # Global gitignore patterns
│   ├── .markdownlintrc  # Markdown linting rules
│   ├── .npmrc           # Node.js package manager config
│   ├── .pip.conf        # Python package manager config
│   ├── .tmux.conf.local # Tmux configuration
│   ├── .vimrc           # Vim configuration
│   ├── cargo.toml       # Rust package manager config
│   ├── ghostty.config   # Ghostty terminal config
│   └── starship.toml    # Starship prompt config
├── scripts/             # Installation and utility scripts
│   ├── install.sh       # Main installation script
│   ├── common.sh        # Shared functions and variables
│   ├── packages.sh      # Package installation module
│   ├── dotfiles.sh      # Dotfiles setup module
│   ├── install_arch.sh  # Arch Linux package installer
│   ├── install_debian.sh # Debian/Ubuntu package installer
│   ├── install_emacs.sh # Emacs installation script
│   ├── install_font.sh  # Font installation script
│   ├── install_go.sh    # Go language installer
│   ├── install_scoop.ps1 # Windows Scoop installer
│   └── Microsoft.PowerShell_profile.ps1 # PowerShell profile
├── shell/               # Shell configuration files
│   ├── .zshrc           # Zsh configuration
│   ├── .zshenv          # Zsh environment variables
│   ├── .zshrc.local     # Local zsh customizations
│   ├── config.fish      # Fish shell configuration
│   └── fish_plugins     # Fish plugin list
├── LICENSE              # Project license
├── logo.png             # Project logo
├── Brewfile             # Homebrew package list (macOS)
├── Dockerfile           # Docker configuration
├── Makefile             # Common tasks automation
├── README.md            # This file
├── _config.yml          # GitHub Pages config
├── .gitignore           # Git ignore patterns
└── logo.png             # Project logo
```

## 🚀 Quick Start

### Linux & macOS

```shell
git clone --depth=1 https://github.com/seagle0128/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

To get help

```shell
> make help

Centaur Dotfiles Management

Available commands:
  install    Install all dotfiles and packages
  update     Update all configurations and packages
  clean      Clean backup files and old configurations
  sync       Synchronize dotfiles with remote repository
  test       Test configuration files
  lint       Lint configuration files
  dev-setup  Setup development environment
  backup     Backup current configurations
  restore    Restore from backup
  help       Show this help message
```

### Windows (PowerShell)

```powershell
git clone --depth=1 https://github.com/seagle0128/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/install_scoop.ps1
```

## 🐳 Docker

```shell
cd ~/.dotfiles
docker build -t centaur/ubuntu .
docker run -it centaur/ubuntu zsh
```

## ⌨️ Shortcuts

- `Alt-c`: cd into the selected directory
- `Ctrl-r`: Paste the selected command from history into the command line
- `Ctrl-t`: Paste the selected file path(s) into the command line
- `TAB`: To completions

## 🎨 Customization

### ZSH Environment

Add your zsh environments in `~/.zshenv`. This is recommended by ZSH officially:

```shell
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.rbenv/shims:$PATH
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
```

### ZSH Local Config

Set your personal zsh configurations in `~/.zshrc.local`:

```shell
# Oh-my-zsh plugin
zinit snippet OMZP::golang
zinit snippet OMZP::python
zinit snippet OMZP::ruby

# Github plugin
zinit light ptavares/zsh-direnv
```

### Git Local Config

Set your git configurations in `~/.gitconfig.local`:

```shell
[commit]
    # Sign commits using GPG
    gpgsign = true

[user]
    name = John Doe
    email = john.doe@example.com
    signingkey = XXXXXXXX
```

## 🛠️ Management

### Using Makefile

```shell
make install      # Install dotfiles
make update       # Update all configurations
make clean        # Clean backup files
make help         # Show available commands
```

### Manual Commands

```shell
# Update dotfiles
cd ~/.dotfiles && git pull --rebase --stat origin master

# Update Zinit plugins
zinit self-update && zinit update -a -p

# Update Homebrew packages (macOS)
brew bundle --global && brew upgrade && brew cleanup

# Update system packages (Linux)
sudo apt update && sudo apt upgrade  # Debian/Ubuntu
sudo pacman -Syu                     # Arch Linux
```

## 📦 Package Management

### macOS (Homebrew)

All packages are managed via `Brewfile`. To install:

```shell
brew bundle --global
```

### Linux

- **Debian/Ubuntu**: Uses `install_debian.sh`
- **Arch Linux**: Uses `install_arch.sh`

### Windows

- **Scoop**: Uses `install_scoop.ps1`
- **Chocolatey**: Alternative package manager

## 🖼️ Screenshots

### Main (with Tmux)

![main](https://user-images.githubusercontent.com/140797/51855591-9717c880-2368-11e9-9270-bbadc3640982.png "Main with tmux")

### Git Log

![git_log](https://user-images.githubusercontent.com/140797/51830877-cf4ce600-232b-11e9-9196-c35a59ebe491.png "Git Log")

### [Centaur Emacs](https://github.com/seagle0128/.emacs.d)

![centaur_emacs](https://user-images.githubusercontent.com/140797/56488858-4e5c4f80-6512-11e9-9637-b9395c46400f.png "Centaur Emacs")

## 🔄 Migration from Old Structure

If you're upgrading from an older version of these dotfiles:

1. Backup your current configurations
2. Run the new installer: `make install`
3. The installer will automatically detect and handle existing configurations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

Related projects: [DevStrap](https://github.com/ray-g/devstrap)

## ☕ Donate

If you think this is helpful for you, please consider paying a cup of coffee for me. Thank you! :smile:

<img src="https://user-images.githubusercontent.com/140797/65818854-44204900-e248-11e9-9cc5-3e6339587cd8.png" alt="Alipay" width="120"/>
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://user-images.githubusercontent.com/140797/65818844-366ac380-e248-11e9-931c-4bd872d0566b.png" alt="Wechat Pay" width="120"/>

<a href="https://paypal.me/seagle0128" target="_blank">
<img src="https://www.paypalobjects.com/digitalassets/c/website/marketing/apac/C2/logos-buttons/optimize/44_Grey_PayPal_Pill_Button.png" alt="PayPal" width="120" />
</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="https://www.buymeacoffee.com/s9giES1" target="_blank">
<img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" width="160"/>
</a>
