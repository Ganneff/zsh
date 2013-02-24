# -*- mode: sh;-*-

ZSHMODPREFIX="zsh/"

# For checking of message status.
zmodload -i ${ZSHMODPREFIX}stat

# For checking job return status.
zmodload -i ${ZSHMODPREFIX}parameter

# Gives strftime and $EPOCHSECONDS
zmodload -i  ${ZSHMODPREFIX}datetime

