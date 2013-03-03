# -*- mode: sh;-*-

# how often should the periodic function be called? I take every 30seconds here.
# Important: The periodic function is only called when
#   - the defined time $PERIOD elapsed
# *AND*
#   - the prompt gets displayed again!
# Its not cron-like "execute this really every 30s in the background"!
#
# But for sanity reasons - make this conditional on existance of tools, but never
# overwrite existing values
if which yacpi > /dev/null; then
        (( ${+PERIOD} )) || export PERIOD=30
        LAPTOP=yacpi
elif which ibam > /dev/null; then
        (( ${+PERIOD} )) || export PERIOD=30
        LAPTOP=ibam
else
        (( ${+PERIOD} )) || unset PERIOD
        unset LAPTOP
fi

# the following is for prompt and gets modified in periodic()
typeset -A ACPIDISPLAY
# I know, this stuff is currently made only for my laptop. But right now i cant be bothered
# to make it more generic
PR_SLASH='${PR_YELLOW}/${PR_RED}'
TOOLONG=0

# I call periodic here one time to have all the variables it sets initialized. Or 
# the first prompt would look ugly.
periodic

# gather version control information for inclusion in a prompt
# we will only be using one variable, so let the code know now.
if is439 && zrcautoload vcs_info && vcs_info; then
    zstyle ':vcs_info:*' max-exports 1
    zstyle ':vcs_info:*' disable cdv darcs mtn tla hg fossil p4
    zstyle ':vcs_info:*' use-prompt-escapes
    zstyle ':vcs_info:*' use_simple
    zstyle ':vcs_info:*' stagedstr      "!"
    zstyle ':vcs_info:*' unstagedstr    "?"
    zstyle ':vcs_info:*' check-for-changes true

    # change vcs_info formats for the prompt
    if [[ "$TERM" == dumb ]]; then
        zstyle ':vcs_info:*' actionformats "(%s%)-[%b|%a] "
	       zstyle ':vcs_info:*' formats       "(%s%)-[%b] "
    else
        # these are the same, just with a lot of colours:
        #	zstyle ':vcs_info:*' actionformats "$%s${PR_YELLOW})${PR_CYAN}-${PR_YELLOW}[${PR_GREEN}%b${PR_YELLOW}|${PR_RED}%a${PR_YELLOW}]${PR_NO_COLOUR}"
	       zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat "%b%{$fg[red]%}:%{$fg[yellow]%}%r"
           zstyle ':vcs_info:git*' formats "%{$fg[yellow]%}%s %{$reset_color%} %{$fg[green]%}%b%{$reset_color%}%m%u%c%{$reset_color%} "
           zstyle ':vcs_info:git*' actionformats "%{$fg[yellow]%}%s%{$reset_color%} %{$fg[green]%}%b%{$reset_color%} $fg[red]%}(%a)%{$reset_color%} %m%u%c%{$reset_color%} "
    fi
fi

PR_BARLENGTH=0

setprompt

# See if our (effective) group has changed at all.  (For instance, we're
# in a subshell that is setgid.)  This happens when i type "newgrp group"
# for whatever reason
# I haven't put this in the precmd function because I don't expect
# my effective group to change over the life of the shell.  It can if
# I'm running with root privileges, but I deliberately don't use zsh for
# root in any case, because that encourages me to not use root for
# anything I don't have to use it for. 
if [[ "$ORIGGID" != "$EGID" ]]; then
  # Set for either normal prompt and xterm title bars.
    GNAME=$(grpname $EGID)
    if [[ "$TERM" = "xterm" ]]; then
        psvar[5]=":$GNAME"
    else
        psvar[5]="g[$GNAME] "
    fi
else
    psvar[5]=
fi
