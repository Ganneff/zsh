# -*- sh -*-

# Update terminfo
__() {
    local terminfo
    local termpath
    if is-callable tic >/dev/null; then
        for terminfo in $ZSH/terminfo/*.terminfo(.N); do
            # We assume that the file is named appropriately for this to work
            termpath=~/.terminfo/${(@)${terminfo##*/}[1]}/${${terminfo##*/}%%.terminfo}
            if [[ ! -e $termpath ]] || [[ $terminfo -nt $termpath ]]; then
                TERMINFO=~/.terminfo tic $terminfo
            fi
        done
    fi
} && __

# Update TERM if we have LC__ORIGINALTERM variable
# Also, try a sensible term where we have terminfo stuff
autoload -U colors zsh/terminfo zsh/termcap
__ () {
    local term
    local colors
    # If the terminal identifies itself as dumb, then we don't try
    # to mess with it. As our system sure may find a definition
    # that it thinks might work (just export the right TERM variable
    # and $terminfo will succeed), yet the dumb terminal won't be able
    # to handle it.
    # Easy verified - remove the if here and use M-x shell in emacs.
    # Have fun.
    if [[ $TERM != "dumb" ]]; then
        for term in $LC__ORIGINALTERM $TERM ${TERM/-256color} xterm; do
            TERM=$term 2> /dev/null
            if (( ${terminfo[colors]:-0} >= 8 )) || \
                (zmodload zsh/termcap 2> /dev/null) && \
                (( ${termcap[Co]:-0} >= 8)); then
                colors
                break
            fi
        done
        unset LC__ORIGINALTERM
        export TERM
        alias sudo="TERM=xterm command sudo"
    fi
} && __


docolors()
{
    if autoload -Uz colors && colors 2>/dev/null ; then
        for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE GREY; do
            eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
            eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
        done
        eval NO_COLOR='%{$reset_color%}'
    else
        BLUE=$'%{\e[1;34m%}'
        RED=$'%{\e[1;31m%}'
        GREEN=$'%{\e[1;32m%}'
        CYAN=$'%{\e[1;36m%}'
        WHITE=$'%{\e[1;37m%}'
        MAGENTA=$'%{\e[1;35m%}'
        YELLOW=$'%{\e[1;33m%}'
        NO_COLOR=$'%{\e[0m%}'
    fi
}

# And while setting up terminal related information, lets decide on some
# more features the terminal may or may not support.
__ () {
    # Start out with default values
    LINEDRAW=false
    COLORS=false

    # Do we support colors?
    local colcount=$(tput colors)
    if [[ ${colcount} -gt 0 ]]; then
        COLORS="true"
        # Colors supported, lets setup the variables so later on they can
        # be used without again having to ensure it is done.
        docolors
    fi

    # Is linedrawing supported?
    if tput acsc >/dev/null || isutf8 || isconsole; then
        LINEDRAW="true"
    fi

    setvar COLORS ${COLORS}
    setvar LINEDRAW ${LINEDRAW}
} && __
