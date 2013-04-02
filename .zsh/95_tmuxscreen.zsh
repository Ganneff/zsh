# -*- mode: sh;-*-

if zstyle -T ':ganneff:config' termstatus; then
    if is-callable tmux; then
        foo=$(tmux list-sessions 2>/dev/null)
        if (( ${#foo} )); then
            preprint "tmux sessions" && echo
            print $foo
            preprint && echo
        fi
    fi

    if is-callable screen; then
        screen -q -ls
        if [[ $? -ne 9 ]]; then
            preprint "screen sessions" && echo
            screen -ls
            preprint && echo
        fi
    fi
fi | sed 's/^/   /'
