#!/bin/bash

# CONFIGURATIONS
################################################################################

export HOMEBREW_DIRECTORY="/opt/homebrew"
export MYZSH_INSTALLED_DIR=$HOME/.myzsh
export ANTIGEN_DIRECTORY=$HOME/.antigen
export DOCKER_DIRECTORY="$HOME/.docker"
export N_PREFIX="$HOME/.n"

# SET PARAMETERS
################################################################################

export LC_ALL=en_AU.UTF-8
export LANG=en_AU.UTF-8

# HELPERS
################################################################################

print_line() {
	echo
	echo "$@"
	echo "--------------------------------------------------------------------------------"
}

# Homebrew
################################################################################

function myzsh_activate_homebrew() {
	HOMEBREW_EXEC="$HOMEBREW_DIRECTORY/bin/brew"
	if [ -f "$HOMEBREW_EXEC" ]; then
		eval "$("$HOMEBREW_EXEC" shellenv)"
		FPATH="$HOMEBREW_DIRECTORY/share/zsh/site-functions:${FPATH}"
		export HOMEBREW_INSTALLED=0
	fi
}

myzsh_is_homebrew_installed() {
	if [ ! -v HOMEBREW_INSTALLED ]; then
		type brew &>/dev/null
		export HOMEBREW_INSTALLED="$?"
	fi
	return "$HOMEBREW_INSTALLED"
}

myzsh_install_homebrew() {
	if ! myzsh_is_homebrew_installed; then
		print_line "Installing homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		myzsh_activate_homebrew
		unset HOMEBREW_INSTALLED
	else
		print_line "Homebrew is already installed"
	fi
}

myzsh_brew_install_or_upgrade() {
	myzsh_install_homebrew
	if brew ls "$@" &>/dev/null; then
		print_line "Brew upgrading" "$@"
		HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$@"
	else
		print_line "Brew installing" "$@"
		HOMEBREW_NO_AUTO_UPDATE=1 brew install "$@"
	fi
}

myzsh_brew_uninstall() {
	if myzsh_is_homebrew_installed; then
		print_line "Brew uninstalling " "$@"
		HOMEBREW_NO_AUTO_UPDATE=1 brew uninstall "$@"
	else
		echo "Homebrew is not installed"
		return 1
	fi
}

# CLI goodies
################################################################################

myzsh_install_cli_tools() {
	myzsh_brew_install_or_upgrade openssl readline sqlite3 xz zlib tcl-tk # required for Python build
	myzsh_brew_install_or_upgrade git wget fd ripgrep fzf htop pstree jq yq tree tmux lazygit shellcheck shfmt bottom bat
	# Install fzf key bindings
	"$(brew --prefix fzf)/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
	[ -f "$HOME"/.tmux.conf ] || ln -s "$MYZSH_INSTALLED_DIR"/tmux.conf "$HOME"/.tmux.conf
	cp "$MYZSH_INSTALLED_DIR"/gitconfig-template "$HOME"/.gitconfig
	myzsh_activate_cli_tools
}

myzsh_uninstall_cli_tools() {
	myzsh_brew_uninstall git wget fd ripgrep fzf htop pstree jq yq tree tmux lazygit shellcheck shfmt bottom bat
	myzsh_brew_uninstall openssl readline sqlite3 xz zlib tcl-tk
	[ -f "$HOME"/.fzf.zsh ] && rm "$HOME"/.fzf.zsh
	true
}

myzsh_activate_cli_tools() {
	if [ -f "$HOME"/.fzf.zsh ]; then
		export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
		export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
		export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
		bindkey "ç" fzf-cd-widget
		# shellcheck disable=SC1091
		source "$HOME"/.fzf.zsh
	fi
}

# ANTIGEN
################################################################################

myzsh_install_antigen() {
	myzsh_brew_install_or_upgrade antigen
	myzsh_activate_antigen
}

myzsh_uninstall_antigen() {
	myzsh_brew_uninstall antigen
	rm -rf "$ANTIGEN_DIRECTORY" &>/dev/null
}

myzsh_activate_antigen() {
	type antigen &>/dev/null && return

	ANTIGEN_EXEC_DIRECTORY="$HOMEBREW_DIRECTORY"/opt/antigen/share/antigen
	if [ -f "$ANTIGEN_EXEC_DIRECTORY"/antigen.zsh ]; then
		# shellcheck disable=SC1091
		source "$ANTIGEN_EXEC_DIRECTORY"/antigen.zsh
		antigen use oh-my-zsh
		antigen bundle key-bindings
		antigen bundle macos
		antigen bundle zsh-users/zsh-autosuggestions
		antigen bundle zsh-users/zsh-syntax-highlighting
		antigen bundle zsh-users/zsh-history-substring-search
		antigen bundle zsh-users/zsh-completions
		antigen bundle git
		antigen bundle tmux
		antigen bundle vi-mode
		antigen apply

		bindkey jk vi-cmd-mode
	fi
}

# Starship (shell prompt)
################################################################################

myzsh_install_starship() {
	myzsh_brew_install_or_upgrade starship
	myzsh_activate_starship
}

myzsh_uninstall_starship() {
	myzsh_brew_uninstall starship
}

myzsh_activate_starship() {
	export STARSHIP_CONFIG="$MYZSH_INSTALLED_DIR"/starship.toml
	starship_activation_file="$HOMEBREW_DIRECTORY"/opt/starship/bin/starship
	[ -f "$starship_activation_file" ] && eval "$($starship_activation_file init zsh)"
	true
}

# RTX
################################################################################

myzsh_install_rtx() {
	myzsh_brew_install_or_upgrade rtx
	rtx_activation_file="$(brew --prefix rtx)/bin/rtx"
	eval "$($rtx_activation_file install)"
	myzsh_activate_rtx
}

myzsh_uninstall_rtx() {
	myzsh_brew_uninstall rtx
	rm -rf "$RTX_PREFIX"
}

myzsh_activate_rtx() {
	rtx_activation_file="$HOMEBREW_DIRECTORY"/opt/rtx/bin/rtx
	[ -f "$rtx_activation_file" ] && eval "$($rtx_activation_file activate zsh)"
	true
}

# Python
################################################################################

myzsh_install_python() {
	# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
	myzsh_brew_install_or_upgrade openssl readline sqlite3 xz zlib tcl-tk pyenv
	print_line "Installing python $1"
	pyenv install "$1"
	pyenv global "$1"
	myzsh_activate_python
	python3 -m pip install --upgrade pip
	echo "Python version:"
	python --version
}

myzsh_activate_python() {
	pyenv_activation_file="$HOMEBREW_DIRECTORY"/opt/pyenv/bin/pyenv
	[ -f "$pyenv_activation_file" ] && eval "$($pyenv_activation_file init -)"
	true
}

# Node
################################################################################

myzsh_install_node() {
	myzsh_brew_install_or_upgrade n
	print_line "Installing NodeJS $1"
	n "$1"
	myzsh_activate_node
	echo "NodeJS version:"
	node --version
}

myzsh_activate_node() {
	[ -d "$N_PREFIX"/bin ] && export PATH="$N_PREFIX/bin:$PATH"
	alias nr="npm run"
	alias nrb="npm run build"
	alias nrc="npm run clean"
	alias nrd="npm run dev"
	alias nrl="npm run lint"
	alias nrf="npm run format"
	alias nrt="npm run test"
	alias ni="npm install"
	alias nid="npm install --save-dev"
	true
}

# Ruby
################################################################################

myzsh_activate_ruby() {
	if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
		export PATH=/opt/homebrew/opt/ruby/bin:$PATH
		gemdir=$(/opt/homebrew/opt/ruby/bin/gem environment gemdir)
		export PATH=$gemdir/bin:$PATH
	fi
	true
}

# Rust
################################################################################

myzsh_activate_rust() {
	# shellcheck disable=SC1091
	[ -d "$HOME/.cargo" ] && . "$HOME/.cargo/env"
	true
}

# Flutter
################################################################################

myzsh_activate_flutter() {
	[ -d "$HOME/flutter" ] && export PATH="$HOME/flutter/bin:$PATH"
	true
}

# Go
################################################################################

myzsh_activate_go() {
	[ -d "$HOME/go" ] && export GOPATH="$HOME/go"
	[ -d "$HOME/go/bin" ] && export PATH="$HOME/go/bin:$PATH"
	true
}

# Java
################################################################################

myzsh_install_java() {
	myzsh_install_homebrew
	myzsh_brew_install_or_upgrade --cask temurin@21
	echo "Java version:"
	java -version
}

myzsh_activate_java() {
	JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
	export JAVA_HOME
	export JAVA_TOOLS_OPTIONS="-Dlog4j2.formatMsgNoLookups=true"
	true
}

# Docker
################################################################################

myzsh_activate_docker() {
	# shellcheck disable=SC1091
	[ -f "$DOCKER_DIRECTORY/init-zsh.sh" ] && (source "$DOCKER_DIRECTORY/init-zsh.sh" || true)
}

# Nerd Fonts
################################################################################
myzsh_install_nerd_fonts() {
	myzsh_brew_install_or_upgrade font-hack-nerd-font
	myzsh_brew_install_or_upgrade font-meslo-lg-nerd-font
	myzsh_brew_install_or_upgrade font-fira-code-nerd-font
}

# Neovim
################################################################################
myzsh_install_neovim() {
	myzsh_install_nerd_fonts
	myzsh_brew_install_or_upgrade neovim stylua luarocks
}

myzsh_activate_neovim() {
	neovim_binary="$HOMEBREW_DIRECTORY/bin/nvim"
	[ -f "$neovim_binary" ] && export EDITOR="$neovim_binary"
	true
}

myzsh_cleanup_neovim() {
	rm -rf "$MYZSH_INSTALLED_DIR"/nvim/plugin/packer_compiled.lua
	rm -rf "$HOME"/.config/nvim
	rm -rf "$HOME"/.local/share/nvim
	rm -rf "$HOME"/.local/state/nvim
	rm -rf "$HOME"/.cache/nvim
}

myzsh_uninstall_neovim() {
	myzsh_brew_uninstall neovim stylua luarocks
	myzsh_cleanup_neovim
}

# Mac key repeat for vscode
################################################################################

myzsh_fix_key_repeat_for_vscode() {
	# Disable key repeat for VSCode
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
}

# Extra completions
################################################################################

myzsh_activate_extra_completions() {
	# check if docker is installed
	if command -v docker &>/dev/null; then
		# if $DOCKER_DIRECTORY/completions does not exist, create it and add the completion file
		if [ ! -d "$DOCKER_DIRECTORY/completions" ]; then
			mkdir -p "$DOCKER_DIRECTORY/completions"
			docker completion zsh >"$DOCKER_DIRECTORY/completions/_docker"
		fi
		FPATH="$DOCKER_DIRECTORY/completions:${FPATH}"
	fi
}

# Keybindings
################################################################################

myzsh_keybindings() {
	# shellcheck disable=SC2154
	bindkey "${terminfo[kcuu1]}" history-substring-search-up
	# shellcheck disable=SC2154
	bindkey "${terminfo[kcud1]}" history-substring-search-down
}

# Turn off beep
setopt nobeep

myzsh_activate_homebrew
myzsh_activate_antigen
myzsh_activate_cli_tools
myzsh_activate_neovim
myzsh_activate_starship
myzsh_activate_rtx
myzsh_activate_python
myzsh_activate_node
myzsh_activate_ruby
myzsh_activate_rust
myzsh_activate_flutter
myzsh_activate_go
myzsh_activate_java
myzsh_activate_docker

myzsh_keybindings
myzsh_activate_extra_completions

[ -x "$HOME/.vocab" ] && "$HOME"/.vocab

# shellcheck disable=SC1091
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

export PATH=$HOME/.local/bin:$PATH
export PAGER="less -FMiX"

# Aliases
alias c="clear"
alias psg="ps aux | grep -v grep | grep"
alias pg="pgrep -ilf"
alias pst="pstree -g3 -s"

date
