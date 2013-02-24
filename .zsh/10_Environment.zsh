# -*- mode: sh;-*-

export SHELL=`which zsh`

## Colors 
c_='['$color[none]";"
_c=m
C_="%{$c_"
_C="$_c%}"

unset has_termcaps
[ $TERM = "urxvt" -o $TERM = "screen" -o $TERM = "rxvt-unicode" ] && has_termcaps="true"
T_=${has_termcaps:+$termcap[as]}
_T=${has_termcaps:+$termcap[ae]}
_t_q=${${has_termcaps:+q}:--}
_t_j=${${has_termcaps:+j}:-[}
_t_k=${${has_termcaps:+k}:-[}
_t_l=${${has_termcaps:+l}:-]}
_t_m=${${has_termcaps:+m}:-]}
_t_t=${${has_termcaps:+t}:-]}
_t_u=${${has_termcaps:+u}:-[}

# I hate kik00l0l colorized prompts, so I'm using a way to
# give a dominant color for each part of the prompt, each of
# these remain still configurable one by one.
# Take a look to set_prompt_colors for these colorizations.
#
# To set the dominant color I'm using this :
#
#  - PS1_ROOT when we are root
#  - PS1_USER for normal usage
#
# I'm storing the resulting dominant color in $prompt_colors[generic]

PS1_ROOT=${PS1_ROOT:-$color[red]}
PS1_USER=${PS1_USER:-$color[blue]}
PS1_YEAH="38;5;82"

export PATH=$PATH:~/sbin:~/local/bin
PATH=/sbin:/usr/sbin:$PATH
export MANPATH=~/man:~/local/share/man:/usr/local/share/man:$MANPATH
export INFOPATH=~/info:~/local/share/info:/usr/local/share/info:$INFOPATH
typeset -gU MANPATH INFOPATH

if [ -w $ZDOTDIR ]; then
    mkdir -p ${ZDOTDIR}/var
	HISTFILE=$ZDOTDIR/var/history.$USER.$HOST
else
	HISTFILE=~$HOME/.zsh_history.$HOST
fi

# Size of history
SAVEHIST=50000
HISTSIZE=$(( $SAVEHIST * 1.10 ))

## maximum size of the directory stack.
DIRSTACKSIZE=20
# $zdirstore is the file used to persist the stack
zdirstore=${ZDOTDIR}/var/.zdirstore
dirpersistrestore

export GPG_TTY=$(tty)

export PAGER="$(which less)"
(( ${+DEBFULLNAME} )) || export DEBFULLNAME='Joerg Jaspert'
(( ${+DEBNAME} )) || export DEBNAME='Joerg Jaspert'
(( ${+DEBEMAIL} )) || export DEBEMAIL='joerg@debian.org'
export LESS='-X -R -f -j 3'
(( ${+TMPDIR} )) || export TMPDIR="$HOME/tmp"
export GREP_OPTIONS='--color=auto'

READNULLCMD=${PAGER}
NULLCMD=${PAGER}

# If its installed - use lesspipe
[ -x /bin/lesspipe ] && eval $(lesspipe)
