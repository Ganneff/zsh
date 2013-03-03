# -*- sh -*-

# Update terminfo
__() {
    local terminfo
    local termpath
    if which tic >/dev/null; then
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
__() {
    local term
    local colors
    for term in $LC__ORIGINALTERM $TERM ${TERM/-256color} xterm-256color xterm; do
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
} && __
