# -*- mode: sh;-*-

ZSHMODPREFIX="zsh/"

# For checking of message status.
is4 && zmodload -i ${ZSHMODPREFIX}stat

# For checking job return status.
is4 && zmodload -i ${ZSHMODPREFIX}parameter

# Gives strftime and $EPOCHSECONDS
is4 && zmodload -i  ${ZSHMODPREFIX}datetime

