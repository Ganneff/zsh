# -*- mode: sh;-*-
############
#
# .zshrc
# Written by Joerg Jaspert <joerg@debian.org>
#
############

# Base directory for all plugins, themes, functions, whatever
ZSH=${HOME}/.zsh

debug ()
{
    [[ "${DEBUG}" = "no" ]] && return
    msg=${1:-""}
    nl=${2:-""}
    echo ${nl} "${msg}$reset_color"
}

# May want to use colors in log output...
[[ "${DEBUG}" = "no" ]] && autoload -U colors && colors
debug "Starting zsh"

# Idea copied from https://github.com/hugues/zdotdir/blob/master/zshrc
# AUTHOR: Hugues Hiegel <hugues@hiegel.fr>
# Most of my config is splitted into files and directories
if [ -d ${ZDOTDIR} ]; then
    for script in ${ZDOTDIR}/??_*.zsh;  do
        debug "Loading ${${script:t:r}/??_/}... " -n
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
                source ${specific_script}
                debug "$fg_no_bold[green]done"
            fi
        done
    done
fi

# For sudo shells
if [ ! -z "$SUDO_USER" ]; then
    export HOME=~$USER
    [ "`pwd`" = ~$SUDO_USER ] && cd
fi
