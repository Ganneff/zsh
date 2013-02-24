# -*- mode: sh;-*-

###
# Key Bindings
# set to emacs style
bindkey -e
# change some defaults
bindkey '^Z' push-input            # "suspend" current line
case "$TERM" in
        linux)  # Linux console
                bindkey '\e[1~' beginning-of-line       # Home 
                bindkey '\e[4~' end-of-line             # End  
                bindkey '\e[3~' delete-char             # Del
                bindkey '\e[2~' overwrite-mode          # Insert  
                ;;
        screen) # The textmode window manager
                # In Linux console
                bindkey '\e[1~' beginning-of-line       # Home
                bindkey '\e[4~' end-of-line             # End  
                bindkey '\e[3~' delete-char             # Del
                bindkey '\e[2~' overwrite-mode          # Insert  
                bindkey '\e[7~' beginning-of-line       # home
                bindkey '\e[8~' end-of-line             # end
                # In rxvt
                bindkey '\eOc' forward-word             # ctrl cursor right
                bindkey '\eOd' backward-word            # ctrl cursor left
                ;;
#       rxvt)
#               bindkey '\e[7~' beginning-of-line       # home
#               bindkey '\e[8~' end-of-line             # end
#               bindkey '\eOc' forward-word             # ctrl cursor right
#               bindkey '\eOd' backward-word            # ctrl cursor left
#               bindkey '\e[3~' delete-char
#               bindkey '\e[2~' overwrite-mode          # Insert
#               ;;
        *xterm*|rxvt)
                bindkey '\e[H' beginning-of-line        # Home
                bindkey '\e[F'  end-of-line             # End
                bindkey '\e[3~' delete-char             # Del
                bindkey '\e[2~' overwrite-mode          # Insert
                bindkey "^[[5C"   forward-word          # ctrl cursor right
                bindkey "^[[5D"   backward-word         # ctrl cursor left
                ;;
esac

#k# Insert a timestamp on the command line (yyyy-mm-dd)
zle -N insert-datestamp
bindkey '^Ed' insert-datestamp

#k# Put the current command line into a \kbd{sudo} call
zle -N sudo-command-line
bindkey "^Os" sudo-command-line

## This function allows you type a file pattern,
## and see the results of the expansion at each step.
## When you hit return, they will be inserted into the command line.
autoload -U insert-files
zle -N insert-files
bindkey "^Xf" insert-files ## C-x-f

## This set of functions implements a sort of magic history searching.
## After predict-on, typing characters causes the editor to look backward
## in the history for the first line beginning with what you have typed so
## far.  After predict-off, editing returns to normal for the line found.
## In fact, you often don't even need to use predict-off, because if the
## line doesn't match something in the history, adding a key performs
## standard completion - though editing in the middle is liable to delete
## the rest of the line.
autoload -U predict-on
zle -N predict-on
#zle -N predict-off
bindkey "^X^R" predict-on ## C-x C-r
#bindkey "^U" predict-off ## C-u

# used when you press M-? on a command line
alias which-command='whence -a'

# in 'foo bar | baz' make a second ^W not eat 'bar |', but only '|'
# this has the disadvantage that in 'bar|baz' it eats all of it.
typeset WORDCHARS='|'$WORDCHARS

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
