# -*- mode: sh;-*-

alias dpb='LANG=C LC_ALL=C dpkg-buildpackage -rfakeroot -k0xB12525C4'
#alias cvsbp='LANG=C LC_ALL=C cvs-buildpackage -F -rfakeroot -k0xB12525C4'
alias pdb='LANG=C LC_ALL=C pdebuild --auto-debsign --debbuildopts -sa --debsign-k B12525C4'

alias pdbis='LANG=C LC_ALL=C linux32 pdebuild --auto-debsign --debsign-k B12525C4 -- --pkgname-logfile --basetgz /var/cache/pbuilder/base_squeeze_i386.tgz --debbuildopts -sa '
alias pdbas='LANG=C LC_ALL=C pdebuild --auto-debsign --debsign-k B12525C4 -- --pkgname-logfile --basetgz /var/cache/pbuilder/base_squeeze_amd64.tgz --debbuildopts -sa '
alias pdbie='LANG=C LC_ALL=C linux32 pdebuild --auto-debsign --debsign-k B12525C4 -- --pkgname-logfile --basetgz /var/cache/pbuilder/base_etch_i386.tgz --debbuildopts -sa '
alias pdbae='LANG=C LC_ALL=C pdebuild --auto-debsign --debsign-k B12525C4 -- --pkgname-logfile --basetgz /var/cache/pbuilder/base_etch_amd64.tgz --debbuildopts -sa '
alias pdbil='LANG=C LC_ALL=C linux32 pdebuild --auto-debsign --debsign-k B12525C4 -- --pkgname-logfile --basetgz /var/cache/pbuilder/base_lenny_i386.tgz --debbuildopts -sa '
alias pdbal='LANG=C LC_ALL=C pdebuild --auto-debsign --debsign-k B12525C4 -- --pkgname-logfile --basetgz /var/cache/pbuilder/base_lenny_amd64.tgz --debbuildopts -sa '
