#!/bin/bash

DOTFILE_DIR=`dirname $0`

log() {
	NEW_LINE=${2:-1}
	if [ $NEW_LINE -eq 1 ];then
		echo "$1"
	else
		echo -n "$1"
	fi

}

remove_and_link() {
	TARGET="${DOTFILE_DIR}/$1"
	DESTINATION=$2
	FORCE=${3:-0}

	log "Trying to link $TARGET to $DESTINATION"
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

	log "Linking $TARGET -> $DESTINATION" 0
	ln -s "$TARGET" "$DESTINATION"
}

link_zsh() {
	log "Linking zsh configs"
	remove_and_link "zsh" "$HOME"/.zsh 1
	remove_and_link "zsh.d" "$HOME"/.zsh.d 1
	remove_and_link "zshrc" "$HOME"/.zshrc 1
	log "Zsh section done"
	log ""
}

link_vim() {
	log "Linking vim"
	remove_and_link "vim" "$HOME/.vim" 1
	remove_and_link "vimrc" "$HOME/.vimrc" 1
	log "Vim section done"
}

link_zsh

