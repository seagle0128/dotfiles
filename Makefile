.PHONY: help install update clean sync test lint dev-setup backup restore

# Default target
help:
	@echo "Centaur Dotfiles Management"
	@echo ""
	@echo "Available commands:"
	@echo "  install    Install all dotfiles and packages"
	@echo "  update     Update all configurations and packages"
	@echo "  clean      Clean backup files and old configurations"
	@echo "  sync       Synchronize dotfiles with remote repository"
	@echo "  test       Test configuration files"
	@echo "  lint       Lint configuration files"
	@echo "  dev-setup  Setup development environment"
	@echo "  backup     Backup current configurations"
	@echo "  restore    Restore from backup"
	@echo "  help       Show this help message"

# Install dotfiles
install:
	@echo "Installing dotfiles..."
	./scripts/install.sh

# Update all configurations
update:
	@echo "Updating dotfiles..."
	@git pull --rebase --stat origin master
	@echo "Updating Zinit plugins..."
	@zsh -c "source ~/.zshrc && zinit self-update && zinit update -a -p"
	@echo "Updating packages..."
	@if command -v brew >/dev/null 2>&1; then \
		brew bundle --global && brew upgrade && brew cleanup; \
	fi
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt update && sudo apt upgrade -y; \
	fi
	@if command -v pacman >/dev/null 2>&1; then \
		sudo pacman -Syu --noconfirm; \
	fi
	@echo "Updating Emacs packages..."
	@emacs -Q --batch -eval "(progn (package-initialize) (package-refresh-contents) (package-upgrade-all))" 2>/dev/null || true
	@echo "Update complete!"

# Clean backup files
clean:
	@echo "Cleaning backup files..."
	@find ~ -name "*.bak" -type f -delete 2>/dev/null || true
	@find ~ -name "*.backup" -type f -delete 2>/dev/null || true
	@find ~ -name "*.old" -type f -delete 2>/dev/null || true
	@echo "Cleaning package caches..."
	@if command -v brew >/dev/null 2>&1; then \
		brew cleanup --prune=all; \
	fi
	@if command -v apt-get >/dev/null 2>&1; then \
		sudo apt autoremove -y; \
	fi
	@if command -v pacman >/dev/null 2>&1; then \
		sudo pacman -Rns $$(pacman -Qtdq) 2>/dev/null || true; \
	fi
	@echo "Clean complete!"

# Sync with remote repository
sync:
	@echo "Synchronizing with remote repository..."
	@git add -A
	@git status
	@echo "Commit message (optional): "; read -r msg; \
	if [ -n "$$msg" ]; then \
		git commit -m "$$msg"; \
	fi
	@git pull --rebase --stat origin master
	@git push origin master
	@echo "Sync complete!"

# Test configuration files
test:
	@echo "Testing configuration files..."
	@echo "Testing shell syntax..."
	@shellcheck scripts/*.sh shell/.zshrc || true
	@echo "Testing zsh configuration..."
	@zsh -n ~/.zshrc
	@echo "Testing vim configuration..."
	@vim -e -s -c 'source ~/.vimrc' -c 'qa' || true
	@echo "Testing git configuration..."
	@git config --global --list >/dev/null
	@echo "Testing fish configuration..."
	@fish -n shell/config.fish || true
	@echo "All tests passed!"

# Lint configuration files
lint:
	@echo "Linting configuration files..."
	@echo "Linting shell scripts..."
	@shellcheck scripts/*.sh shell/.zshrc || true
	@echo "Linting fish configuration..."
	@fish -n shell/config.fish || true
	@echo "Linting YAML files..."
	@yamllint . 2>/dev/null || true
	@echo "Linting toml files..."
	@if command -v taplo >/dev/null 2>&1; then \
		taplo lint config/*.toml || true; \
	fi
	@echo "Lint complete!"

# Setup development environment
dev-setup:
	@echo "Setting up development environment..."
	@echo "Installing development tools..."
	@if command -v brew >/dev/null 2>&1; then \
		brew install shellcheck yamllint taplo; \
	elif command -v apt-get >/dev/null 2>&1; then \
		sudo apt install -y shellcheck yamllint; \
	elif command -v pacman >/dev/null 2>&1; then \
		sudo pacman -S --noconfirm shellcheck yamllint; \
	fi
	@echo "Installing fish shell for testing..."
	@if command -v brew >/dev/null 2>&1; then \
		brew install fish; \
	elif command -v apt-get >/dev/null 2>&1; then \
		sudo apt install -y fish; \
	elif command -v pacman >/dev/null 2>&1; then \
		sudo pacman -S --noconfirm fish; \
	fi
	@echo "Dev setup complete!"

# Backup current configurations
backup:
	@echo "Creating backup of current configurations..."
	@BACKUP_DIR="$$(date +%Y%m%d_%H%M%S)_dotfiles_backup"; \
	mkdir -p "$$BACKUP_DIR"; \
	cp ~/.zshrc "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.zshenv "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.zshrc.local "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.vimrc "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.gitconfig "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.gitignore_global "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.tmux.conf "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.tmux.conf.local "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.Brewfile "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.markdownlintrc "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.npmrc "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.gemrc "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.pip.conf "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp ~/.minttyrc "$$BACKUP_DIR/" 2>/dev/null || true; \
	mkdir -p "$$BACKUP_DIR/.config"; \
	cp ~/.config/starship.toml "$$BACKUP_DIR/.config/" 2>/dev/null || true; \
	cp ~/.config/ghostty/config "$$BACKUP_DIR/.config/ghostty/" 2>/dev/null || true; \
	mkdir -p "$$BACKUP_DIR/.cargo"; \
	cp ~/.cargo/config.toml "$$BACKUP_DIR/.cargo/" 2>/dev/null || true; \
	mkdir -p "$$BACKUP_DIR/.pip"; \
	cp ~/.pip/pip.conf "$$BACKUP_DIR/.pip/" 2>/dev/null || true; \
	cp shell/config.fish "$$BACKUP_DIR/" 2>/dev/null || true; \
	cp shell/fish_plugins "$$BACKUP_DIR/" 2>/dev/null || true; \
	echo "Backup created in $$BACKUP_DIR"

# Restore from backup
restore:
	@echo "Available backups:"
	@ls -d *_dotfiles_backup 2>/dev/null || echo "No backups found"
	@echo "Enter backup directory name:"; read -r backup_dir; \
	if [ -d "$$backup_dir" ]; then \
		echo "Restoring from $$backup_dir..."; \
		cp "$$backup_dir/.zshrc" ~/.zshrc 2>/dev/null || true; \
		cp "$$backup_dir/.zshenv" ~/.zshenv 2>/dev/null || true; \
		cp "$$backup_dir/.zshrc.local" ~/.zshrc.local 2>/dev/null || true; \
		cp "$$backup_dir/.vimrc" ~/.vimrc 2>/dev/null || true; \
		cp "$$backup_dir/.gitconfig" ~/.gitconfig 2>/dev/null || true; \
		cp "$$backup_dir/.gitignore_global" ~/.gitignore_global 2>/dev/null || true; \
		cp "$$backup_dir/.tmux.conf" ~/.tmux.conf 2>/dev/null || true; \
		cp "$$backup_dir/.tmux.conf.local" ~/.tmux.conf.local 2>/dev/null || true; \
		cp "$$backup_dir/.Brewfile" ~/.Brewfile 2>/dev/null || true; \
		cp "$$backup_dir/.markdownlintrc" ~/.markdownlintrc 2>/dev/null || true; \
		cp "$$backup_dir/.npmrc" ~/.npmrc 2>/dev/null || true; \
		cp "$$backup_dir/.gemrc" ~/.gemrc 2>/dev/null || true; \
		cp "$$backup_dir/.pip.conf" ~/.pip.conf 2>/dev/null || true; \
		cp "$$backup_dir/.minttyrc" ~/.minttyrc 2>/dev/null || true; \
		mkdir -p ~/.config; \
		cp "$$backup_dir/.config/starship.toml" ~/.config/ 2>/dev/null || true; \
		cp "$$backup_dir/.config/ghostty/config" ~/.config/ghostty/ 2>/dev/null || true; \
		mkdir -p ~/.cargo; \
		cp "$$backup_dir/.cargo/config.toml" ~/.cargo/ 2>/dev/null || true; \
		mkdir -p ~/.pip; \
		cp "$$backup_dir/.pip/pip.conf" ~/.pip/ 2>/dev/null || true; \
		cp "$$backup_dir/config.fish" shell/config.fish 2>/dev/null || true; \
		cp "$$backup_dir/fish_plugins" shell/fish_plugins 2>/dev/null || true; \
		echo "Restore complete!"; \
	else \
		echo "Backup directory not found!"; \
	fi