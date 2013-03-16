# -*- mode: sh;-*-

# Want one more piece in my prompt here, dinstall status
zstyle ':prompt:ganneff:left:full:setup' items \
    ulcorner line openparentheses user at host pts closeparentheses line history \
    line dinstall line shell-level line flexline openparentheses path closeparentheses line urcorner newline \
    llcorner line rc openparentheses time closeparentheses line vcs line change-root pipe space

zstyle ':prompt:ganneff:extra:dinstall' pre '${PR_CYAN}'
zstyle ':prompt:ganneff:extra:dinstall' post '${PR_NO_COLOR}'
zstyle ':prompt:ganneff:extra:dinstall' token '$DINSTALL'
zstyle ':prompt:ganneff:extra:dinstall' precmd jj_update_dinstall

zmodload zsh/mapfile

jj_update_dinstall () {
    DINSTALL="${${(z)${(f)mapfile[/srv/ftp.debian.org/web/dinstall.status]}[2]}[3,-1]}"
}
