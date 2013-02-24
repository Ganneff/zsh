# -*- mode: sh;-*-

# No core dumps
ulimit -c 0

umask 022

# Want a halfway sane terminal
[[ -t 0 ]] && /bin/stty erase  "^H" intr  "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null

# watch for everybody but me
watch=(notme)
# check every 5 min for login/logout activity
LOGCHECK=300
WATCHFMT='%n %a %l from %m at %t.'
