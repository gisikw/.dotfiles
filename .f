#!/bin/bash

_f_edit() {
	(cd $HOME/.dotfiles && vim -c "NvimTreeToggle" config.yml -c "wincmd w" && .f)
}

_f_install() {
	command_exists() {
		which "$1" >/dev/null 2>&1
	}

	missing_dependencies=()

	command_exists git || missing_dependencies+=("git")
	command_exists yq || missing_dependencies+=("yq")

	if [ ${#missing_dependencies[@]} -gt 0 ]; then
		echo "Installing missing dependencies: ${missing_dependencies[*]}"

		if command_exists brew; then
			brew install "${missing_dependencies[@]}"
		elif command_exists apt; then
			sudo apt update && sudo apt install -y "${missing_dependencies[@]}"
		else
			echo "Error: Neither apt nor brew is available. Please install the following missing dependencies manually: ${missing_dependencies[*]}"
			return 1
		fi
	fi

	git clone --quiet git@github.com:gisikw/.dotfiles.git $HOME/.dotfiles >/dev/null 2>&1
	[ -f $HOME/.bash_profile ] && echo 'source $HOME/.dotfiles/.f' >>$HOME/.bash_profile
	[ -f $HOME/.bashrc ] && echo 'source $HOME/.dotfiles/.f' >>$HOME/.bashrc
	[ -f $HOME/.zshrc ] && echo 'source $HOME/.dotfiles/.f' >>$HOME/.zshrc

	echo "Installation complete. Please restart your shell or run . ~/.dotfiles/.f"
}

_f_uninstall() {
	while read symlink; do
		rm -rf $symlink
	done < <(yq '.symlinks | keys' ~/.dotfiles/config.yml | sed 's/- //')
	rm -rf $HOME/.dotfiles
	if [[ "$(uname)" == "Darwin" ]]; then
		sed -i '' '/source \$HOME\/.dotfiles\/.f/d' $HOME/.bash_profile 2>/dev/null
		sed -i '' '/source \$HOME\/.dotfiles\/.f/d' $HOME/.bashrc 2>/dev/null
		sed -i '' '/source \$HOME\/.dotfiles\/.f/d' $HOME/.zshrc 2>/dev/null
	else
		sed -i '/source \$HOME\/.dotfiles\/.f/d' $HOME/.bash_profile 2>/dev/null
		sed -i '/source \$HOME\/.dotfiles\/.f/d' $HOME/.bashrc 2>/dev/null
		sed -i '/source \$HOME\/.dotfiles\/.f/d' $HOME/.zshrc 2>/dev/null
	fi
	echo "Dotfiles uninstalled. Please restart your shell."
}

_f_main() {
	function github_available() {
		ping -c 1 -W 1 github.com >/dev/null 2>&1
	}
	function commit_dotfile_changes() {
		(
			cd $HOME/.dotfiles
			if ! test -z "$(git status --porcelain)"; then
				git add --all >/dev/null 2>&1
				git commit -m "Automatic update" >/dev/null 2>&1
			fi
		)
	}
	function update_dotfile_repository() {
		(
			cd ~/.dotfiles
			git pull origin main >/dev/null 2>&1
			git push origin main >/dev/null 2>&1 &
		)
	}
	if github_available; then
		commit_dotfile_changes
		update_dotfile_repository
	fi
}

_f_show_usage() {
	echo "Usage: .f [edit|install|uninstall]"
}

.f() {
	local command="$1"

	case "$command" in
	edit)
		_f_edit
		;;
	install)
		_f_install
		;;
	uninstall)
		_f_uninstall
		;;
	*)
		if [ -n "$1" ]; then
			_f_show_usage
		else
			_f_main
		fi
		;;
	esac
}

if [[ $ZSH_NAME ]]; then
	current_file_path="${(%):-%x}"
else
	current_file_path="${BASH_SOURCE[0]}"
fi
if [ "$(realpath $current_file_path)" = "$HOME/.dotfiles/.f" ]; then
	source $HOME/.dotfiles/init.sh
fi
