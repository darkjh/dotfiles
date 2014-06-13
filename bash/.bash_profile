# This file serves for the main bashrc config file
# It will load .extra, .exports, .functions, .aliases in HOME directory
# Put configs that you dont want to commit in .extra

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we do not have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

# bash-completion
if [ "$PS1" ]; then
    # Run bash completion code
    if [ -r /usr/share/bash-completion/bash_completion ]; then
	# Source completion code.
	. /usr/share/bash-completion/bash_completion
    fi
fi

# prompt
# powerline
function _update_ps1_scala() {
    export PS1="$(~/projects/scala/powerline-shell-scala/target/powerline-client $?)"
}
# override PS1
export PROMPT_COMMAND="_update_ps1_scala && echo -ne \"\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007\""
# . ~/projects/python/powerline/powerline/bindings/bash/powerline.sh
# export PROMPT_COMMAND="echo -ne \"\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007\""

# z
. ~/projects/shell/z/z.sh

# Turn off XON/XOFF flow control
# thus enables C-s/C-r command search
# Credit: http://stackoverflow.com/questions/791765
stty -ixon

# source other parts
for file in ~/.{extra,exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file
