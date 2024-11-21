# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# ----- BASH HISTORY SESSION MANAGEMENT -----
# Set the global history file
GLOBAL_HISTFILE=~/.bash_history
HISTSIZE=500000
HISTFILESIZE=10000000

# Directory for temporary session history files
HISTFILE_SESSION_DIR=~/.bash_history_sessions
mkdir -p "$HISTFILE_SESSION_DIR"

# Generate a unique history file for each tmux pane or session
if [ -n "$TMUX" ]; then
    TMUX_PANE_ID=$(tmux display-message -p "#{pane_id}" | tr -d '%')
    HISTFILE_SESSION="$HISTFILE_SESSION_DIR/history.${TMUX_PANE_ID}_$$"
else
    HISTFILE_SESSION=$(mktemp "$HISTFILE_SESSION_DIR/history.XXXXXX")
fi

ls -l "$HISTFILE_SESSION"

# Use the session-specific history file
export HISTFILE=$HISTFILE_SESSION

# Initialize the session-specific history with the global history
if [ ! -f "$HISTFILE_SESSION" ]; then
    cp "$GLOBAL_HISTFILE" "$HISTFILE_SESSION"
fi

# Force bash to reload history from the session-specific file
history -r

# Save session-specific history to the global history on exit
trap 'history -a; cat "$HISTFILE_SESSION" | grep -Fxv -f $GLOBAL_HISTFILE >> $GLOBAL_HISTFILE; rm -f "$HISTFILE_SESSION"' EXIT

# Recover orphaned session history files on login
if compgen -G "$HISTFILE_SESSION_DIR/history.*" > /dev/null; then
    for orphan in "$HISTFILE_SESSION_DIR"/history.*; do
        if [ "$orphan" != "$HISTFILE_SESSION" ]; then
            cat "$orphan" | grep -Fxv -f "$GLOBAL_HISTFILE" >> "$GLOBAL_HISTFILE"
            rm -f "$orphan"
        fi
    done
else
    echo "DEBUG: No orphaned history files to recover."
fi
# ------------------------------------------

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

source $HOME/.agent-bridge.sh
export PROMPT_COMMAND='history -a'
export BASH_ENV=~/.bashrc_remote
