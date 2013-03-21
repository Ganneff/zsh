# -*- mode: sh;-*-

if cmd_exists fortune && zstyle -T ':ganneff:config' fortune; then
	preprint "Fortune" && echo
	fortune | fmt -s -w 74
	preprint && echo
	echo
fi | sed 's/^/   /'
