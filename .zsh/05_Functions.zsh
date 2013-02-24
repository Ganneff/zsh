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
	my_color=${2-"$prompt_colors[generic]"}

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

chpwd()
{
	if ( cmd_exists git && test -d .git ); then
		# Shows tracked branches and modified files
		git checkout HEAD 2>&1 | sed 's/^/   /'
	fi
}

# Taken from oh-my-zsh
dirpersiststore () {
    dirs -p | perl -e 'foreach (reverse <STDIN>) {chomp;s/([& ])/\\$1/g ;print "if [ -d $_ ]; then pushd -q $_; fi\n"}' >| $zdirstore
}

dirpersistrestore () {
    if [ -f $zdirstore ]; then
        source $zdirstore
    fi
}

zsh_stats() {
  history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}

_jj_ssh() {
    # TERM is one of the variables that is usually allowed to be
    # transmitted to the remote session. The remote host should have the
    # appropriate termcap or terminfo file to handle the TERM you
    # provided. When connecting to random hosts, this may not be the
    # case if your TERM is somewhat special. A good fallback is
    # xterm. Most terminals are compatible with xterm and all hosts have
    # a termcap or terminfo file to handle xterm. Therefore, for some
    # values of TERM, we fallback to xterm.
    #
    # Now, you may connect to a host where your current TERM is fully
    # supported and you will get xterm instead (which means 8 base
    # colors only). There is no clean solution for this. You may want to
    # reexport the appropriate TERM when logged on the remote host or
    # use commands like this: ssh -t XXXXX env TERM=$TERM emacsclient -t
    # -c
    #
    # If the remote host uses the same zshrc than this one, there is
    # something in `$ZSH/rc/00-terminfo.zsh` to restore the appropriate
    # terminal (saved in `LC__ORIGINALTERM`).
    #
    # The problem is quite similar for LANG and LC_MESSAGES. We reset
    # them to C to avoid any problem with hosts not having your locally
    # installed locales. See this post for more details on this:
    # http://vincent.bernat.im/en/blog/2011-zsh-zshrc.html
    #
    # Also, when the same ZSH configuration is used on the remote host,
    # the locale is reset with the help of 12-Locale.zsh
    case "$TERM" in
        rxvt-256color|rxvt-unicode*)
            LC__ORIGINALTERM=$TERM TERM=xterm LANG=C LC_MESSAGES=C command ssh "$@"
            ;;
        *)
            LANG=C LC_MESSAGES=C command ssh "$@"
            ;;
    esac
}

_jj_first_non_optional_arg() {
    local args
    args=( "$@" )
    args=( ${(R)args:#-*} )
    print -- $args[1]
}

# Alter window title
_jj_title () {
    [ -t 1 ] || return
    emulate -L zsh
    local title
    title=${@//[^[:alnum:]\/>< ._~:=?@-]/ }
    case $TERM in
        screen*)
            print -n "\ek$title\e\\"
            print -n "\e]1;$title\a"
            print -n "\e]2;$title\a"
            ;;
        rxvt*|xterm*)
            print -n "\e]1;$title\a"
            print -n "\e]2;$title\a"
            ;;
    esac
}

ssh() {
    _jj_title $(_jj_first_non_optional_arg "$@")
    _jj_ssh "$@"
}
