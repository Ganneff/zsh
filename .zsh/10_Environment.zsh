# -*- mode: sh;-*-

export SHELL=`which zsh`

## Colors
c_='['$color[none]";"
_c=m
C_="%{$c_"
_C="$_c%}"

unset has_termcaps
[ $TERM = "urxvt" -o $TERM = "screen" -o $TERM="screen-256color" -o $TERM = "rxvt-unicode" ] && has_termcaps="true"
T_=${has_termcaps:+$termcap[as]}
_T=${has_termcaps:+$termcap[ae]}
_t_q=${${has_termcaps:+q}:--}
_t_j=${${has_termcaps:+j}:-[}
_t_k=${${has_termcaps:+k}:-[}
_t_l=${${has_termcaps:+l}:-]}
_t_m=${${has_termcaps:+m}:-]}
_t_t=${${has_termcaps:+t}:-]}
_t_u=${${has_termcaps:+u}:-[}

export PATH=$PATH:~/sbin:~/local/bin
PATH=/sbin:/usr/sbin:$PATH
export MANPATH=~/man:~/local/share/man:/usr/local/share/man:$MANPATH
export INFOPATH=~/info:~/local/share/info:/usr/local/share/info:$INFOPATH
typeset -gU MANPATH INFOPATH

if [ -w $ZDOTDIR ]; then
    mkdir -p ${ZDOTDIR}/var
	HISTFILE=$ZDOTDIR/var/history.$USER.$HOST
else
	HISTFILE=~$HOME/.zsh_history.$HOST
fi

# Size of history
SAVEHIST=50000
HISTSIZE=$(( $SAVEHIST * 1.10 ))

## maximum size of the directory stack.
DIRSTACKSIZE=20
DIRSTACKFILE=${ZDOTDIR}/var/.zdirs
# $zdirstore is the file used to persist the stack
zdirstore=${ZDOTDIR}/var/.zdirstore
is434 && dirpersistrestore

export GPG_TTY=$(tty)

export PAGER="$(which less)"
(( ${+DEBFULLNAME} )) || export DEBFULLNAME='Joerg Jaspert'
(( ${+DEBNAME} )) || export DEBNAME='Joerg Jaspert'
(( ${+DEBEMAIL} )) || export DEBEMAIL='joerg@debian.org'
export LESS='-X -R -f -j 3'
(( ${+TMPDIR} )) || export TMPDIR="$HOME/tmp"
export GREP_OPTIONS='--color=auto'

# solarized ls colors
if [[ ! "${TERM}" == dumb ]]; then
    export LS_COLORS='no=00:fi=00:di=36:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.sh=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.xml=32:*.rdf=32:*.css=32:*.js=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.dot=31:*.dotx=31:*.xls=31:*.xlsx=31:*.ppt=31:*.pptx=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;32:*~=01;32:*#=01;32:*.bak=01;33:*.BAK=01;33:*.old=01;33:*.OLD=01;33:*.org_archive=01;33:*.off=01;33:*.OFF=01;33:*.dist=01;33:*.DIST=01;33:*.orig=01;33:*.ORIG=01;33:*.swp=01;33:*.swo=01;33:*,v=01;33:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:';
fi

READNULLCMD=${PAGER}
NULLCMD=${PAGER}

# If its installed - use lesspipe
[ -x /bin/lesspipe ] && eval $(lesspipe)

## Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

[[ -f "$HOME/.local/share/mc/skins/solarized.ini" ]] && export MC_SKIN="solarized"

# set variable debian_chroot if running in a chroot with /etc/debian_chroot
if [[ -z "$debian_chroot" ]] && [[ -r /etc/debian_chroot ]] ; then
    debian_chroot="chroot: $(cat /etc/debian_chroot)"
fi
