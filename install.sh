#!/data/data/com.termux/files/usr/bin/sh

# Default settings
ZSH_RC=~/.zshrc
DERMUX=${DERMUX:-~/.dermux}
REPO=${REPO:-socheatsok78/.dermux}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

error() {
	echo ${RED}"Error: $@"${RESET} >&2
}

underline() {
	echo "$(printf '\033[4m')$@$(printf '\033[24m')"
}

hai() {
	echo " ---> ${BLUE}$@${RESET}"
}

setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

setup_dotfile() {
	# Prevent the cloned repository from having insecure permissions. Failing to do
	# so causes compinit() calls to fail with "command not found: compdef" errors
	# for users with insecure umasks (e.g., "002", allowing group writability). Note
	# that this will be ignored under Cygwin by default, as Windows ACLs take
	# precedence over umasks except for filesystems mounted with option "noacl".
	umask g-w,o-w

	if [ -d "$DERMUX" ]; then
		return 0
	fi

	command_exists git || {
		error "git is not installed"
		exit 1
	}

	hai "Cloning .dermux..."

	git clone -c core.eol=lf -c core.autocrlf=false \
		-c fsck.zeroPaddedFilemode=ignore \
		-c fetch.fsck.zeroPaddedFilemode=ignore \
		-c receive.fsck.zeroPaddedFilemode=ignore \
		--depth=1 --branch "$BRANCH" "$REMOTE" "$DERMUX" || {
		error "git clone of .dermux repo failed"
		exit 1
	}

	echo
}

setup_antigen() {
	hai "Installing antigen..."

	if [ -f "$DERMUX/antigen.zsh" ]; then
		return
	fi

	curl -L git.io/antigen > $DERMUX/antigen.zsh
}

setup_system() {
	hai "Installing curl..."
	pkg install -y libcurl curl

	hai "Installing zsh..."
	pkg install -y zsh
}

main() {
	setup_color

	if ! command_exists zsh; then
		echo "${YELLOW}Zsh is not installed.${RESET} Please install zsh first."
		exit 1
	fi

	setup_system
	setup_dotfile
	setup_antigen

	printf "$GREEN"
	cat <<-'EOF'
		         __
		    ____/ /__  _________ ___  __  ___  __
		   / __  / _ \/ ___/ __ `__ \/ / / / |/_/
		 _/ /_/ /  __/ /  / / / / / / /_/ />  <
		(_)__,_/\___/_/  /_/ /_/ /_/\__,_/_/|_|   ....is now installed!

	EOF
	printf "$RESET"
}

main "$@"
