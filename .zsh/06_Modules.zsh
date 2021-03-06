# -*- mode: sh;-*-

ZSHMODPREFIX="zsh/"

# For checking of message status.
is4 && zmodload -i ${ZSHMODPREFIX}stat

# For checking job return status.
is4 && zmodload -i ${ZSHMODPREFIX}parameter

# Gives strftime and $EPOCHSECONDS
is4 && zmodload -i  ${ZSHMODPREFIX}datetime


# Funky run-help hooks
autoload run-help-git
autoload run-help-svn

# escape URLs automagically
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# we use extended_glob, which breaks some things in git. Like,
# git log @{1}..@{1}. This module from Akinori MUSHA helps.
autoload -Uz git-escape-magic
git-escape-magic

## Allow known mime types to be used as 'command'
if is42 && zstyle -t ':ganneff:config' mimesetup true; then
    autoload -U zsh-mime-setup
    zsh-mime-setup
fi
