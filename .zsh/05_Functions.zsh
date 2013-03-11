# -*- mode: sh;-*-

## 	User-defined functions
#
cmd_exists ()
{
	\which -p $1 >/dev/null 2>&1
}

preprint()
{
	local my_color i
	my_color=${2-"$'%{\e[1;31m%}'"}

	hbar=$T_
	for i in {1..$((74 - ${#1} - 5))}; do
		hbar=${hbar}$_t_q
	done
	hbar=${hbar}$_T

	if [ "$1" != "" ]; then
		print -Pn "${C_}$my_color;1${_C}${hbar}$T_$_t_u$_T${C_}0;$my_color${_C} $1 ${C_}0;$my_color;1${_C}$T_$_t_t$_t_q$_T\r${C_}0${_C}"
	else
		print -Pn "${C_}$my_color;1${_C}${hbar}$T_$_t_q$_t_q$_t_q$_t_q$_t_q$_T${C_}0${_C}"
	fi
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
if is434; then
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

docolors()
{
    if zrcautoload colors && colors 2>/dev/null ; then
        for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
            eval BOLD_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
            eval $color='%{$fg[${(L)color}]%}'
            (( count = $count + 1 ))
        done
        NO_COLOR="%{${reset_color}%}"
    else
        BLUE=$'%{\e[1;34m%}'
        RED=$'%{\e[1;31m%}'
        GREEN=$'%{\e[1;32m%}'
        CYAN=$'%{\e[1;36m%}'
        WHITE=$'%{\e[1;37m%}'
        MAGENTA=$'%{\e[1;35m%}'
        YELLOW=$'%{\e[1;33m%}'
        NO_COLOR=$'%{\e[0m%}'
    fi
}
