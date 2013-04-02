# -*- mode: sh;-*-

## 	User-defined functions
#
preprint()
{
	local my_color start stop pipe1 pipe2 hbar out

    if [[ "$COLORS" == "true" ]]; then
	    my_color=${2:-${BOLD_RED}}
    else
        my_color=${2:-""}
    fi
    if [[ $LINEDRAW == "true" ]]; then
        # Some stuff to help us draw nice lines
        if isutf8 || isconsole; then
            start=""
            stop=""
            hbar="─"
            PR_ULCORNER="┌"
            PR_LLCORNER="└"
            PR_LRCORNER="┘"
            PR_URCORNER="┐"
        else
            start="$terminfo[smacs]"
            stop="$terminfo[rmacs]"
            hbar="q"
            pipe1="u"
            pipe2="t"
            draw="q"
        fi
    else
        start=""
        stop=""
        hbar="-"
        pipe1="|"
        pipe2="|"
        draw="-"
    fi
    hbar="${start}${${(l:$(( 74 - ${#1} - 5 ))::X:)}//X/$hbar}${stop}"
    out="${my_color}${hbar}${start}"

	if [[ "${1}" != "" ]]; then
        out+="${pipe1}${stop}${my_color} $1 ${my_color}${start}${pipe2}"
    else
        out+="${draw}${draw}${draw}${draw}"
    fi
    out+="${draw}${stop}${NO_COLOR}\r"

    print -Pn -- $out
}

_jj_chpwd()
{
	if ( is-callable git && test -d .git ); then
		# Shows tracked branches and modified files
		git checkout HEAD 2>&1 | sed 's/^/   /'
	fi
}

if is434 ; then
    add-zsh-hook chpwd _jj_chpwd
else
    function chpwd() {
        _jj_chpwd
    }
fi

# Idea taken from oh-my-zsh, but code is different
function dirpersistrestore () {
    if [ -f ${DIRSTACKFILE} ]; then
        dirstack=( ${(f)"$(< ${DIRSTACKFILE} )"} )
        if zstyle -t ':ganneff:config' dirstackhandling dirpersist; then
            cd -q ${dirstack[-1]}
        fi
    fi
}

function dirpersiststore () {
    print -l ${(Oau)dirstack} ${PWD} >| ${DIRSTACKFILE}
}

if is434; then
    add-zsh-hook zshexit dirpersiststore
else
    echo "Sorry, zsh version too old"
fi
