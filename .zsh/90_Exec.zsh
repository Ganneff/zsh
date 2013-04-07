# -*- mode: sh;-*-

if is-callable fortune && zstyle -T ':ganneff:config' fortune; then
	preprint "Fortune" && echo
	fortune | fmt -s -w 74
	preprint && echo
	echo
fi | sed 's/^/   /'

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
        # So lets work on "exit level higher than 9"...
        if [[ $? -gt 9 ]]; then
            preprint "screen sessions" && echo
            screen -ls
            preprint && echo
        fi
    fi
fi | sed 's/^/   /'
