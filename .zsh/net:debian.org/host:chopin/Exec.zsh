# -*- mode: sh;-*-

if cmd_exists fortune; then
	preprint "Fortune" && echo
	fortune | fmt -s -w 74
	preprint "" && echo
	echo
fi | sed 's/^/   /'

eval $(/usr/local/bin/dak admin c db-shell)
