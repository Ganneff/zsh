# -*- mode: sh;-*-

hash -d ftp=/srv/ftp-master.debian.org
hash -d queue=/srv/ftp-master.debian.org/queue
hash -d ftppub=/srv/ftp.debian.org
hash -d bdo=/srv/backports-master.debian.org
hash -d upload=/srv/upload.debian.org

cdpath=( . /srv/ftp-master.debian.org /srv/ftp-master.debian.org/queue /srv/ftp.debian.org )
