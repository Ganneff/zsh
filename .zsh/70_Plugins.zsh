# -*- mode: sh;-*-

# Config for plugins loaded below


# for per-directory-history
HISTORY_BASE=${ZDOTDIR}/var/dirhist
mkdir -p ${HISTORY_BASE}

function bindkey() {
    if zstyle -t ':ganneff:config' pluginbindkeys; then
        # User allows plugins to bind keys
        builtin bindkey "$@"
        [[ "${DEBUG}" = "no" ]] && return
        print -b -r "$fg_no_bold[cyan]plugin allowed to run${reset_color}: 'bindkey ${(q)@}'"
    else
        [[ "${DEBUG}" = "no" ]] && return
        print -b -r "$fg_no_bold[red]plugin forbidden to run${reset_color}: 'bindkey ${(q)@}'"
    fi
}

__ () {
    local plugdir=${ZDOTDIR}/plugins
    if [ -d ${plugdir} ]; then
        typeset -a plugins
        zstyle -a ':ganneff:config' plugins plugins \
            || plugins=(
            git-extras.plugin.zsh
            history-substring-search.zsh
            per-directory-history.plugin.zsh
        )
        for file in $plugins; do
            debug "PLUGIN: Trying to load ${file}"...
            source ${plugdir}/${file}
            debug "PLUGIN: $fg_no_bold[green]done"
        done
    fi

    # And now (possibly) oh-my-zsh style plugins
    if [[ -d ${ZDOTDIR}/plugins/ohmy ]]; then
        typeset -a omplug
        zstyle -a ':ganneff:config' ohmyplugins omplug
        for plug in ${omplug}; do
            if [[ -f ${ZDOTDIR}/plugins/ohmy/${plug}/${plug}.plugin.zsh ]]; then
                source ${ZDOTDIR}/plugins/ohmy/${plug}/${plug}.plugin.zsh
            fi
        done
    fi
} && __

unfunction bindkey

