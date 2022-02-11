### WE CAN COLORIZE COMPLETION HERE. Take colors from .dircolors or LS_COLORS if set ###
[ -f $HOME/.dircolors ] && eval $(dircolors -b $HOME/.dircolors)
export ZLS_COLORS="${LS_COLORS}"

### Load colors for futhrer use ###
autoload -U colors && colors

### ALIASES ###
alias cp='cp -i'
alias cup='cvs update -Ad'
alias cv='cdb'
alias cvi='cup; vim history'
alias d='/bin/ls -ablF'
alias del_tmp='find -type f -name "*~" -exec rm -vf -- "{}" \;'
alias del_zero='find -type f -size 0 -exec rm -vf -- "{}" \;'
alias f='file'
alias grep='grep --colour=auto'
alias ln='ln -i'
alias ls='ls --color=auto'
alias m='make'
alias man='man -a'
alias mv='mv -i'
alias myc='commith -b -l'
alias rdesktop='rdesktop -u kalavan -k en-us -K -g 1270x820 -z -C -P'
alias rm='rm -i'
alias sdel_tmp='echo "find -type f -name \"*~\" -exec rm -vf -- \"{}\" \;"'
alias sdel_zero='echo "find -type f -size 0 -exec rm -vf -- \"{}\" \;"'
alias ssh='ssh -o ServerAliveInterval=120'
alias t='type -a'
alias f3='ssh f3@nblack2'
alias az-acc='az account show -o table'
alias az-dev='az account set --subscription Device-Communication-Development; az-acc'
alias az-int='az account set --subscription Device-Communication-Integration; az-acc'
alias az-stg='az account set --subscription Device-Communication-Staging; az-acc'
alias az-preprod='az account set --subscription Device-Communication-PreProd; az-acc'
alias az-prod='az account set --subscription Device-Communication-Prod; az-acc'
alias az-devops='az account set --subscription VI-DevOps; az-acc'
alias az-shared='az account set --subscription Device-Communication-Shared; az-acc'
alias az-lt='az account set --subscription Device-Communication-Load-Test-Framework; az-acc'
alias check_hostmapping='/home/kalavan/CVS/admin/scripts/host-mapping/host-mapping-verifier.py /home/kalavan/CVS/admin/axit.pl/host-mapping.csv'
rem_ssh_key(){ sed -ie "$1d"  ~/.ssh/known_hosts ;}
upload_dns(){
	echo -en "Verifing hostmaps... ";
	check_hostmapping
	err=$?
	if [ $err -eq 0 ]; then
		echo "OK.";
		echo -en "Commiting changes... ";
		myc -f -M "Kalavan updates DNS" host-mapping.csv ;
		echo "OK.";
	else
		echo "Error code is $err. Aborting"
	fi
}

check_rrd_length(){
	/bin/egrep -h "host_name|service_description" $* | awk '/host_name/{h=$2} /service_description/{print h"_"$2}' | while read l; do echo -en "$l "; echo $l | wc -c; done | sort -k2n
}

urlencode(){
	python2 -c "import urllib; print urllib.quote('''$1''')"
}

upload_ssh_key(){
	#1 - server
	#2 - user
	#3 - password
	#4 - key
	
	SERVER=$1;
	USER=$2;
	PASSWORD=$3;
	SSH_KEY=$4;

	expect - << EOF
	spawn ssh-copy-id -i ${SSH_KEY} ${USER}@${SERVER} 
		expect {
			"*password:" { 
		               send "$PASSWORD\r"
				exp_continue
			}
			"Are you sure you want to continue connecting*" { 
				send "yes\r"
				exp_continue
			}
		       "to make sure we haven't added extra keys that you weren't expecting." { send_user "OK\r" }
			timeout {
				send_user "Timeout occurred!!\r"
			}
		}
EOF
}

### PATH FOR AUTOLOAD FUNCTIONS ###
fpath=(~/.zsh/Functions $fpath)

### EXPORTS ###
#export LIBVA_DRIVER_NAME="vdpau"
#export VDPAU_DRIVER="nvidia"
export CVSROOT=":pserver:kalavan@cvs.axit.pl:2401/cvs/cvs"
export EDITOR=vim
export NPM_PACKAGES="${HOME}/.npm-packages"
export PATH=$PATH:/home/kalavan/bin:/home/kalavan/.local/bin:$NPM_PACKAGES/bin
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket" 

#zstyle ':completion:*' completer _list _expand _complete _ignored _approximate
zstyle ':completion:*' completer _oldlist _expand _complete _files
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=3
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true

### INSERT ARG FROM PREVIOUS LINE, ITERATE BETWEEN THEM ###
### For M-, and M-. ###
zstyle ':completion:history-words:*' list no
zstyle ':completion:history-words:*' menu yes
zstyle ':completion:history-words:*' remove-all-dups yes

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle :compinstall filename '/home/kalavan/.zshrc'

### COMPLETION OPTIONS ###
setopt COMPLETE_IN_WORD #Allows completion in the middle of the word

autoload -U compinit
compinit
# End of lines added by compinstall

### ZSH SETTINGS ###
setopt interactivecomments

### VARIOUS FUNCTONS ###
autoload -U zmv	#mv with style!

### VERSION CONTROL SYSTEM ###
#autoload -Uz vcs_info
zstyle ':vcs_info:*' enable svn cvs git
#zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
#zstyle ':vcs_info:*' formats 	   '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
#zstyle ':vcs_info:(svn|cvs):*' branchformat '%b%F{1}:%F{3}%r'



### INPUTRC ###
# do not bell on tab-completion
set bell-style none

set meta-flag on
set input-meta on
set convert-meta off
set output-meta on

# for linux console and RH/Debian xterm
bindkey -e
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e/" _history-complete-older
bindkey "\e," _history-complete-newer

# for rxvt
bindkey "\e[8~" end-of-line

# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line


## Someone once accused zsh of not being as complete as Emacs, because it
## lacks Tetris and an adventure game.
#autoload -U tetris
#zle -N tetris
#bindkey "^Xt" tetris ## C-x-t to play
#emulate sh -c 'source /etc/profile'

### EDIT command in full screen editor ###
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

### CDARGS ###
if [[ -f ~/.zsh.d/cdargs.conf.zsh ]]; then 
	source ~/.zsh.d/cdargs.conf.zsh
fi

#if [ -f /usr/share/cdargs/cdargs-bash.sh ]; then
#        source /usr/share/cdargs/cdargs-bash.sh
#fi


### HISTORY SETTINGS ###
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=100000
setopt sharehistory
setopt extendedhistory
setopt autocd extendedglob notify
setopt HIST_VERIFY   # Needs confirmation after using BANG-History

## maximum size of the directory stack.
DIRSTACKSIZE=20

# If nonnegative, commands whose combined user and system execution times
# (measured in seconds) are greater than this value have timing
# statistics printed for them.
REPORTTIME=5


### AXITOWY HISTORY HOOK DLA ZSH :) ###
HISTCONTROL=""
HISTTIMEFORMAT=`echo -en ' %s\v'`
HISTTIMEFILE="${HOME}/.bash_time_history"
HISTTIMEMININTERVAL="10"

function history_hook {
	local history_ret="$?"
	#local history_cur="$(history -D -1)"
	local history_cur="$(fc -lnt "%Y-%m-%d %H:%M:%S" -1 -1)"
	test -n "${history_last}" -a "${history_last}" != "${history_cur}" && echo -n "${history_ret} ${history_cur}" | awk -vHISTTIMEMININTERVAL="${HISTTIMEMININTERVAL}" -vHISTTIMEFILE="${HISTTIMEFILE}" '
BEGIN {
	endtime = systime();
	HISTTIMEMININTERVAL += 0;
}

NR > 1 {
	command = command "\n" $0;
	next;
}

NR == 1 {
	retcode   = $1 + 0;
	starttime_d = $2;
	starttime_h = $3;
	$1="";
	$2="";
	$3="";
	command   = $0;

}

END {
	gsub("^[ ]+","",command);
	if (length(command) > 0) {
		split(starttime_d,d,"-");
		split(starttime_h,h,":");
		starttime_sec=mktime(d[1]" "d[2]" "d[3]" "h[1]" "h[2]" "h[3]);

		if (endtime - starttime_sec >= HISTTIMEMININTERVAL)
			time = starttime_d " " starttime_h strftime("-%H:%M:%S", endtime);
		else
			time = starttime_d " " starttime_h;
		if (retcode == 0) {
			printf("\033[02;33m%s \033[00;02;36m%s\033[00m\n", time, command);
			printf("%s %s\n", time, command) >> HISTTIMEFILE;
		} else {
			printf("\033[02;33m%s \033[00;02;31m%s # %d\033[00m\n", time, command, retcode);
			printf("%s %s # %d\n", time, command, retcode) >> HISTTIMEFILE;
		}
	}
}
'
	history_last="${history_cur}"
}

### PROMPT ###
autoload -Uz add-zsh-hook

ps1_user_color=2
test `id -u` -eq 0 && ps1_user_color=1
unset ps1_user_color

#To set colors use:
# $fg[color] 
# reset_color
# Embed colors in %{ %} for escape sequences be recognized correctly, eg: %{$fg[red]%}

# copy of working prompt:
#PS1="[%(!.%{$fg[red]%}%U%B%n%b%u.%n)%{$reset_color%}@%m%(1j.%{$fg[magenta]%} J:%j.)%{$fg[magenta]%} H:%! %{$reset_color%}%{$fg[green]%}%~%{$reset_color%}]%# "

#%F{green}%B%K{green}█▓▒░%F{white}%K{green}%B%n@%m%b%F{green}%K{black}█▓▒░%F{white}%K{black}%B %D{%a %b %d} %D{%I:%M:%S%P} 
PS1="[%(!.%{$fg[red]%}%U%B%n%b%u.%n)%{$reset_color%}@%m%(1j.%{$fg[magenta]%} J:%j.)%{$fg[magenta]%} H: %! %{$reset_color%}%{$fg[green]%}%~%{$reset_color%}]%# "
#PS2="%B$fg[yellow]%_>%b$reset_color"

autoload -U promptinit && promptinit && prompt kalavan
add-zsh-hook precmd history_hook

autoload -U +X bashcompinit && bashcompinit

source ~/lib/azure-cli/az.completion
source <(kubectl completion zsh)
complete -C '/home/kalavan/bin/aws_completer' aws

if [ -f /home/kalavan/azure/az.completion ]; then
	source /home/kalavan/azure/az.completion
fi

#vim: 

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

### DirEnv initiation
eval "$(direnv hook zsh)"

