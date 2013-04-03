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
        # According to the manpage the exit level with -q can be one
        # of 9==no sessions, 10==not attachable sessions,
        # 11 (or more)==sessions.
        # But of course there are bugs, and so 8 is also returned in
        # certain conditions when there are no sessions.
        if [[ $? -ne 9 ]] || [[ $? -ne 8 ]]; then
            preprint "screen sessions" && echo
            screen -ls
            preprint && echo
        fi
    fi
fi | sed 's/^/   /'
