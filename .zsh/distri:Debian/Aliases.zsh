# -*- mode: sh;-*-

alias showpkg='apt-cache showpkg'
alias agr='LANG=C sudo aptitude remove'
alias agp='LANG=C sudo aptitude purge'
alias dclean='LANG=C LC_ALL=C fakeroot debian/rules clean'
alias cpan='perl -MCPAN -e shell'

#a3# Execute \kbd{apt-cache search}
alias acs='apt-cache search'
#a3# Execute \kbd{apt-cache show}
alias acw='apt-cache show'
#a3# Execute \kbd{apt-cache policy}
alias acp='apt-cache policy'
#a3# Execute \kbd{apt-get dist-upgrade}
salias adg="apt-get dist-upgrade"
#a3# Execute \kbd{apt-get install}
salias agi="apt-get install"
#a3# Execute \kbd{aptitude install}
salias ati="aptitude install"
#a3# Execute \kbd{apt-get upgrade}
salias ag="apt-get upgrade"
#a3# Execute \kbd{apt-get update}
salias au="apt-get update"
#a3# Execute \kbd{aptitude update ; aptitude safe-upgrade}
salias -a up="aptitude update ; aptitude safe-upgrade"
#a3# Execute \kbd{grep-excuses}
alias ge='grep-excuses'

#a3# List installed Debian-packages sorted by size
alias debs-by-size="dpkg-query -Wf 'x \${Installed-Size} \${Package} \${Status}\n' | sed -ne '/^x  /d' -e '/^x \(.*\) install ok installed$/s//\1/p' | sort -nr"

#a3# Search using apt-file
alias afs='apt-file search --regexp'

# Prints apt history
# Usage:
#   apt-history install
#   apt-history upgrade
#   apt-history remove
#   apt-history rollback
#   apt-history list
# Based On: http://linuxcommando.blogspot.com/2008/08/how-to-show-apt-log-history.html
apt-history () {
  case "$1" in
    install)
      zgrep --no-filename 'install ' $(ls -rt /var/log/dpkg*)
      ;;
    upgrade|remove)
      zgrep --no-filename $1 $(ls -rt /var/log/dpkg*)
      ;;
    rollback)
      zgrep --no-filename upgrade $(ls -rt /var/log/dpkg*) | \
        grep "$2" -A10000000 | \
        grep "$3" -B10000000 | \
        awk '{print $4"="$5}'
      ;;
    list)
      zcat $(ls -rt /var/log/dpkg*)
      ;;
    *)
      echo "Parameters:"
      echo " install - Lists all packages that have been installed."
      echo " upgrade - Lists all packages that have been upgraded."
      echo " remove - Lists all packages that have been removed."
      echo " rollback - Lists rollback information."
      echo " list - Lists all contains of dpkg logs."
      ;;
  esac
}
