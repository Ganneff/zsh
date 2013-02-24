# -*- mode: sh;-*-

(( $+commands[locale] )) && __() {
    local locales
    local locale
    locales=( "LANG de_DE.utf8 en_GB.utf8 C.UTF-8 C" \
              "LC_MESSAGES en_GB.utf8 de_DE.utf8 C.UTF-8 C" )
    for locale in $locales; do
        for l in $=locale[(w)2,-1]; do
            if locale -a | grep -qx $l; then
                export $locale[(w)1]=$l
                break
            fi
        done
    done
} && __ 2> /dev/null
