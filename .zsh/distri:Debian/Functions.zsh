# -*- mode: sh;-*-

#f1# View Debian's changelog of a given package
dchange() {
    emulate -L zsh
    if [[ -r /usr/share/doc/$1/changelog.Debian.gz ]] ; then
        $PAGER /usr/share/doc/$1/changelog.Debian.gz
    elif [[ -r /usr/share/doc/$1/changelog.gz ]] ; then
        $PAGER /usr/share/doc/$1/changelog.gz
    else
        if which aptitude ; then
            echo "No changelog for package $1 found, using aptitude to retrieve it."
            aptitude changelog $1
        else
            echo "No changelog for package $1 found, sorry."
            return 1
        fi
    fi
}
_dchange() { _files -W /usr/share/doc -/ }
