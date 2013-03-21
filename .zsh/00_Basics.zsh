# -*- mode: sh;-*-

# No core dumps
ulimit -c 0

local _umask
zstyle -s ':ganneff:config' umask _umask
_umask=${_umask:-022}
umask $_umask

# Want a halfway sane terminal
[[ -t 0 ]] && /bin/stty erase  "^H" intr  "^C" susp "^Z" dsusp "^Y" stop "^S" start "^Q" kill "^U"  >& /dev/null

# watch for everybody but me
watch=(notme)
# check every 5 min for login/logout activity
LOGCHECK=300
WATCHFMT='%n %a %l from %m at %t.'

# autoload wrapper - use this one instead of autoload directly
# We need to define this function as early as this, because autoloading
# 'is-at-least()' needs it.
function zrcautoload() {
    emulate -L zsh
    setopt extended_glob
    local fdir ffile
    local -i ffound

    ffile=$1
    (( ffound = 0 ))
    for fdir in ${fpath} ; do
        [[ -e ${fdir}/${ffile} ]] && (( ffound = 1 ))
    done

    (( ffound == 0 )) && return 1
    if [[ $ZSH_VERSION == 3.1.<6-> || $ZSH_VERSION == <4->* ]] ; then
        autoload -U ${ffile} || return 1
    else
        autoload ${ffile} || return 1
    fi
    return 0
}

# Some things need to be done very early
# the following helper functions have been taken from the grml zshrc
# (wherever they got them from)
# check for version/system
# check for versions (compatibility reasons)
is4(){
    [[ $ZSH_VERSION == <4->* ]] && return 0
    return 1
}

is41(){
    [[ $ZSH_VERSION == 4.<1->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is42(){
    [[ $ZSH_VERSION == 4.<2->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is425(){
    [[ $ZSH_VERSION == 4.2.<5->* || $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is43(){
    [[ $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is433(){
    [[ $ZSH_VERSION == 4.3.<3->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is434(){
    [[ $ZSH_VERSION == 4.3.<4->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is435(){
    [[ $ZSH_VERSION == 4.3.<5->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is437(){
    [[ $ZSH_VERSION == 4.3.<7->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is439(){
    [[ $ZSH_VERSION == 4.3.<9->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

isdarwin(){
    [[ $OSNAME == Darwin* ]] && return 0
    return 1
}

isfreebsd(){
    [[ $OSNAME == FreeBSD* ]] && return 0
    return 1
}

if ! [[ ${ZSH_VERSION} == 3.1.<7->*      \
     || ${ZSH_VERSION} == 3.<2->.<->*    \
     || ${ZSH_VERSION} == <4->.<->*   ]] ; then

    printf '-!-\n'
    printf '-!- In this configuration we try to only enable features supported by the shell\n'
    printf '-!- version found on the system. However you are running a particular old zsh\n'
    printf '-!- "version %s.\n' "$ZSH_VERSION"
    printf '-!- While this *may* work, it might as well fail.\n'
    printf '-!-\n'
    printf '-!- Please consider updating to at least version 3.1.7 of zsh.\n'
    printf '-!-\n'
    printf '-!- DO NOT EXPECT THIS TO WORK FLAWLESSLY!\n'
    printf '-!- If it does today, you'\''ve been lucky.\n'
    printf '-!-\n'
    printf '-!- Ye been warned!\n'
    printf '-!-\n'

    function zstyle() { : }
fi

for paths in "$fpath[@]"; do
    for func in "$paths"/*(N:t); do
        zrcautoload $func
    done
done
unset paths
