# -*- mode: sh;-*-

# Config for plugins loaded below


# for per-directory-history
HISTORY_BASE=${ZDOTDIR}/var/dirhist
mkdir -p ${HISTORY_BASE}

if [ -d ${ZDOTDIR}/plugins ]; then
    for file in ${ZDOTDIR}/plugins/*.zsh; do
        debug "Loading ${file}"... -n
        source $file
        debug "$fg_no_bold[green]done"
    done
fi
