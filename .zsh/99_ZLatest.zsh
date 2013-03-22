# -*- mode: sh;-*-

# Lets remove stuff that we only really needed during zsh setup.
__ () {
    emulate -L zsh
    local -a funcs
    # is439 is not here, as its used in precmd
    # is434 is used in agent()
    funcs=(is4 is41 is42 is425 is43 is433 isdarwin isfreebsd salias setvar)
    
    for func in $funcs ; do
        [[ -n ${functions[$func]} ]] \
            && unfunction $func
    done
    return 0
} && __
unfunction __

