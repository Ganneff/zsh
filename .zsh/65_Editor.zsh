# -*- mode: sh;-*-
# Setup EDITOR
mkdir -p $ZDOTDIR/run/

__ () {
    local -a editors
    local editor
    zstyle -a ':ganneff:config' editors editors \
        || editors=(
        "emacs-snapshot -Q -D -nw" # Fast emacs
        "emacs24 -Q -D -nw" # Fast emacs
        "emacs23 -Q -D -nw" # Fast emacs
        "emacs22 -Q -D -nw" # Fast emacs
        "mcedit"            # 
        "vim" "vi"        # vi
        "editor")         # fallback
    for editor in $editors; do
        (( $+commands[$editor[(w)1]] )) && {
            # Some programs may not like to have arguments
            if [[ $editor == *\ * ]]; then
                export EDITOR=$ZDOTDIR/run/editor-$HOST-$UID
                cat <<EOF >| $EDITOR
#!/bin/sh
exec $editor "\$@"
EOF
                chmod +x $EDITOR
            else
                export EDITOR=$editor
            fi
            break
        }
    done
} && __

[[ -z $EDITOR ]] || {
    # Maybe use emacsclient?
    if zstyle -T ':ganneff:config' emacsclient; then
        (( $+commands[emacsclient] )) && {
            export ALTERNATE_EDITOR=$EDITOR
            export EDITOR=$ZDOTDIR/run/eeditor-$HOST-$UID
            cat <<EOF >| $EDITOR
#!/bin/sh
exec emacsclient -t "\$@"
EOF
            chmod +x $EDITOR
            alias e=$EDITOR
        }
    fi
}

unset VISUAL
