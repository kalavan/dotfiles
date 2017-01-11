#!/bin/bash

DOTFILE_DIR=$(cd $(dirname $0) && pwd)
CUR_DIR=`pwd`

log() {
	NEW_LINE=${2:-1}
	if [ $NEW_LINE -eq 1 ];then
		echo "$1"
	else
		echo -n "$1"
	fi

}

remove_and_link() {
	SOURCE="${DOTFILE_DIR}/$1"
	DESTINATION=$2
	FORCE=${3:-0}

	log "Trying to link $SOURCE to $DESTINATION"
	if [ -e "$DESTINATION" -o -L "$DESTINATION" ]; then
		log "$DESTINATION already exists"
		if [ $FORCE -eq 1 ]; then
			log "Removing $DESTINATION"
			rm -rf -- "$DESTINATION"
		else
			log "Force not set, deal with it and re-run script"
			exit 1
		fi
	fi

	log "Linking $SOURCE -> $DESTINATION" 0
	ln -s "$SOURCE" "$DESTINATION"
}

link_zsh() {
	log "Linking zsh configs"
	remove_and_link "zsh" "$HOME"/.zsh 1
	remove_and_link "zsh.d" "$HOME"/.zsh.d 1
	remove_and_link "zshrc" "$HOME"/.zshrc 1
	log "Zsh section done."
	log ""
}

link_vim() {
	log "Linking vim"
	remove_and_link "vim" "$HOME/.vim" 1
	remove_and_link "vimrc" "$HOME/.vimrc" 1
	log "Vim section done."
	log ""
}

link_screen() {
	log "Linking screenrc"
	remove_and_link "screenrc" "$HOME/.screenrc" 1
	log "Screen section done."
	log ""
}

log "Getting submodules"
cd $DOTFILE_DIR
git submodule update --init --recursive
cd $CUR_DIR
log "Done updating submodules"
log ""

link_zsh
link_vim
link_screen
