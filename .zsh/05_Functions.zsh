# -*- mode: sh;-*-

## 	User-defined functions
#
cmd_exists ()
{
	\which -p $1 >/dev/null 2>&1
}

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
        start="$terminfo[smacs]"
        stop="$terminfo[rmacs]"
        hbar="${start}${(l:$(( 74 - ${#1} - 5 ))::q:)}${stop}"
        pipe1="u"
        pipe2="t"
        draw="q"
    else
        start=""
        stop=""
        hbar="${start}${(l:$((74 - ${#1} - 5))::-:)}${stop}"
        pipe1="|"
        pipe2="|"
        draw="-"
    fi
    out="${my_color}${hbar}${start}"
    
	if [[ "${1}" != "" ]]; then
        out+="${pipe1}${stop}${my_color} $1 ${my_color}${start}${pipe2}"
    else
        out+="${draw}${draw}${draw}${draw}"
    fi
    out+="${draw}${stop}${NO_COLOR}\r"
    
    print -Pn -- $out
}

normal_user ()
{
	if [ -e /etc/login.defs ]; then
		eval `grep -v '^[$#]' /etc/login.defs | grep "^UID_" | tr -d '[:blank:]' | sed 's/^[A-Z_]\+/&=/'`
		[ \( $UID -ge $UID_MIN \) ]
	else
		[ "`whoami`" != "root" ]
	fi
}

privileged_user ()
{
	! normal_user
}

_jj_chpwd()
{
	if ( cmd_exists git && test -d .git ); then
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

# Taken from oh-my-zsh
if zstyle -T ':ganneff:config' dirpersiststore && is434; then
    function dirpersiststore () {
        dirs -p | perl -e 'foreach (reverse <STDIN>) {chomp;s/([& ])/\\$1/g ;print "if [ -d $_ ]; then pushd -q $_; fi\n"}' >| $zdirstore
    }
    add-zsh-hook zshexit dirpersiststore

    function dirpersistrestore () {
        if [ -f $zdirstore ]; then
            source $zdirstore
        fi
    }
fi
