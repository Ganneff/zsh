# -*- mode: sh;-*-

# No core dumps
ulimit -c 0

# Tiny helper function to set variables/values according to styles
# removed after config load
setvar () {
    variable=$1
    default=$2
    command=${3:-0}

    local tempvar
    zstyle -s ':ganneff:config' ${variable} tempvar
    tempvar=${tempvar:-${default}}
    if (( ${command} )); then
        ${variable} ${tempvar}
    else
        export ${variable}=${tempvar}
    fi
}

setvar umask 022 1

# watch for everybody but me
watch=(notme)
# check every 5 min for login/logout activity
setvar LOGCHECK 302
setvar WATCHFMT '%n %a %l from %m at %t.'

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

is4311(){
    [[ $ZSH_VERSION == 4.3.<11->* || $ZSH_VERSION == 4.<4->* \
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

isutf8(){
    [[ $(locale charmap) == "UTF-8" ]] && return 0
    return 1
}

isconsole(){
    [[ $TERM == "linux" ]] && return 0
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

# Now that FPATH is set correctly, do autoloaded functions.
# autoload all functions in $FPATH - that is, all files in
# each component of the array $fpath.  If there are none, feed the list
# it prints into /dev/null.
for paths in "$fpath[@]"; do
    autoload -U "$paths"/*(N:t) >/dev/null
done
unset paths
