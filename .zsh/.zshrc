# -*- mode: sh;-*-
############
#
# .zshrc
# Written by Joerg Jaspert <joerg@debian.org>
#
############

# Base directory for all plugins, themes, functions, whatever
ZSH=${HOME}/.zsh

if [[ ${DEBUG} != no ]]; then
    debug () {
        [[ "${DEBUG}" = "no" ]] && return
        msg=${1:-""}
        nl=${2:-""}
        echo ${nl} "${msg}$reset_color"
    }
else
    debug () {}
    # May want to use colors in log output...
    autoload -U colors && colors
fi

debug "Starting zsh"

if zstyle -T ':ganneff:config' zrecompile; then
    autoload -Uz zrecompile
    zrecompile -q -p -R ${ZDOTDIR}/.zshrc -- -M ${ZDOTDIR}/var/.zcompdump
    maybe_compile () {
        zrecompile -q -p -U -R ${1}
    }
else
    maybe_compile () {}
fi

# Idea copied from https://github.com/hugues/zdotdir/blob/master/zshrc
# AUTHOR: Hugues Hiegel <hugues@hiegel.fr>
# Most of my config is splitted into files and directories
if [ -d ${ZDOTDIR} ]; then
    for script in ${ZDOTDIR}/??_*.zsh;  do
        lscript=${script:t:r}
        debug "Loading ${lscript/??_/}... " -n
        maybe_compile ${script}
        source $script
        debug "$fg_no_bold[green]done"
        for i in "net:$DOMAIN"                                     \
            "host:$HOST"                                           \
            "sys:$OSNAME"                                          \
            "distri:$DISTRI"                                       \
            "user:$USER"                                           \
            "user:$SUDO_USER"                                      \
            "net:$DOMAIN/host:$HOST"                               \
            "net:$DOMAIN/sys:$OSNAME"                              \
            "net:$DOMAIN/distri:$DISTRI"                           \
            "net:$DOMAIN/user:$USER"                               \
            "net:$DOMAIN/user:$SUDO_USER"                          \
            "net:$DOMAIN/host:$HOST/sys:$OSNAME"                   \
            "net:$DOMAIN/host:$HOST/distri:$DISTRI"                \
            "net:$DOMAIN/host:$HOST/user:$USER"                    \
            "net:$DOMAIN/host:$HOST/user:$SUDO_USER"               \
            "net:$DOMAIN/host:$HOST/sys:$OSNAME"                   \
            "net:$DOMAIN/host:$HOST/sys:$OSNAME/distri:$DISTRI"    \
            "net:$DOMAIN/host:$HOST/sys:$OSNAME/user:$USER"        \
            "net:$DOMAIN/host:$HOST/sys:$OSNAME/user:$SUDO_USER"   \
            "host:$HOST/sys:$OSNAME"                               \
            "host:$HOST/distri:$DISTRI"                            \
            "host:$HOST/user:$USER"                                \
            "host:$HOST/user:$SUDO_USER"                           \
            "host:$HOST/sys:$OSNAME/distri:$DISTRI"                \
            "host:$HOST/sys:$OSNAME/user:$USER"                    \
            "host:$HOST/sys:$OSNAME/user:$SUDO_USER"
        do
            specific_script=${script:h}/$i/${${script:t}/??_/}
            #debug "Checking $specific_script... "
            if [ -r ${specific_script} ]; then
                debug "Loading $i/${${specific_script:t:r}/??_/}... " -n
                maybe_compile ${specific_script}
                source ${specific_script}
                debug "$fg_no_bold[green]done"
            fi
        done
        if [[ -f ${ZDOTDIR}/${lscript}.zsh.local ]]; then
            debug "Loading local ${lscript/??_/}... " -n
            maybe_compile ${lscript}.zsh.local
            source ${script}.local
            debug "$fg_no_bold[green]done"
        fi
    done
fi

# For sudo shells
if [ ! -z "$SUDO_USER" ]; then
    export HOME=~$USER
    [ "`pwd`" = ~$SUDO_USER ] && cd
fi

[[ -f ${ZDOTDIR}/.zshlate ]] && source ${ZDOTDIR}/.zshlate || true
unfunction debug
unfunction maybe_compile

if zstyle -t ':ganneff:config' starttime true; then
    end_time=$(( $(( $(date +%s) * 1000000000 )) + $(date +%N) ))
    duration=$(( $end_time - $_start_time ))
    echo "ZSH startup took roughly $(( $duration / 1000000.0 ))ms"
    unset end_time; unset duration
fi
unset _start_time
