# -*- mode: sh;-*-
###
# Key Bindings
zmodload zsh/terminfo
typeset -gA key_info
key_info=(
  'Control'   '\C-'
  'Escape'    '\e'
  'Meta'      '\M-'
  'Backspace' "^?"
  'Delete'    "^[[3~"
  'F1'        "$terminfo[kf1]"
  'F2'        "$terminfo[kf2]"
  'F3'        "$terminfo[kf3]"
  'F4'        "$terminfo[kf4]"
  'F5'        "$terminfo[kf5]"
  'F6'        "$terminfo[kf6]"
  'F7'        "$terminfo[kf7]"
  'F8'        "$terminfo[kf8]"
  'F9'        "$terminfo[kf9]"
  'F10'       "$terminfo[kf10]"
  'F11'       "$terminfo[kf11]"
  'F12'       "$terminfo[kf12]"
  'Insert'    "$terminfo[kich1]"
  'Home'      "$terminfo[khome]"
  'PageUp'    "$terminfo[kpp]"
  'End'       "$terminfo[kend]"
  'PageDown'  "$terminfo[knp]"
  'Up'        "$terminfo[kcuu1]"
  'Left'      "$terminfo[kcub1]"
  'Down'      "$terminfo[kcud1]"
  'Right'     "$terminfo[kcuf1]"
  'BackTab'   "$terminfo[kcbt]"
)
# Set empty $key_info values to an invalid UTF-8 sequence to induce silent
# bindkey failure.
for key in "${(k)key_info[@]}"; do
  if [[ -z "$key_info[$key]" ]]; then
    key_info["$key"]='�'
  fi
done

# First set it back to known defaults
bindkey -d

# now, our main map is the emacs style
bindkey -e

bindkey "$key_info[Home]"                    beginning-of-line
bindkey "$key_info[End]"                     end-of-line
bindkey "$key_info[Insert]"                  overwrite-mode
bindkey "$key_info[Delete]"                  delete-char
bindkey "$key_info[Backspace]"               backward-delete-char
bindkey "$key_info[Left]"                    backward-char
bindkey "$key_info[Right]"                   forward-char

# Setup some more bindings to be more like emacs.
for key ("$key_info[Escape]"{B,b}) bindkey -M emacs "$key" emacs-backward-word
for key ("$key_info[Escape]"{F,f}) bindkey -M emacs "$key" emacs-forward-word
bindkey -M emacs "$key_info[Escape]$key_info[Left]" emacs-backward-word
bindkey -M emacs "$key_info[Escape]$key_info[Right]" emacs-forward-word

# Kill to the beginning of the line.
for key in "$key_info[Escape]"{K,k} bindkey -M emacs "$key" backward-kill-line

# Redo.
bindkey -M emacs "$key_info[Escape]_" redo

# "suspend" current line
bindkey "$key_info[Control]Z" push-input

# Bind Shift + Tab to go to the previous menu item.
bindkey "$key_info[BackTab]" reverse-menu-complete

#k# Insert a timestamp on the command line (yyyy-mm-dd)
zle -N insert-datestamp
bindkey "$key_info[Control]Ed" insert-datestamp

#k# Put the current command line into a \kbd{sudo} call
zle -N sudo-command-line
bindkey "$key_info[Control]Os" sudo-command-line

## This function allows you type a file pattern,
## and see the results of the expansion at each step.
## When you hit return, they will be inserted into the command line.
if is4 && zrcautoload insert-files && zle -N insert-files; then
    #k# Insert files and test globbing
    bindkey "$key_info[Control]Xf" insert-files ## C-x-f
fi

## This set of functions implements a sort of magic history searching.
## After predict-on, typing characters causes the editor to look backward
## in the history for the first line beginning with what you have typed so
## far.  After predict-off, editing returns to normal for the line found.
## In fact, you often don't even need to use predict-off, because if the
## line doesn't match something in the history, adding a key performs
## standard completion - though editing in the middle is liable to delete
## the rest of the line.
if is4 && zrcautoload predict-on && zle -N predict-on; then
    #zle -N predict-off
    bindkey "$key_info[Control]X$key_info[Control]R" predict-on ## C-x C-r
    #bindkey "^U" predict-off ## C-u
fi

# in 'foo bar | baz' make a second ^W not eat 'bar |', but only '|'
# this has the disadvantage that in 'bar|baz' it eats all of it.
typeset WORDCHARS='|'$WORDCHARS

# press ctrl-x ctrl-e for editing command line in $EDITOR or $VISUAL
if is4 && zrcautoload edit-command-line && zle -N edit-command-line; then
    bindkey '$key_info[Control]x$key_info[Control]e' edit-command-line
fi

# move cursor between chars when typing '', "", (), [], and {}
magic-single-quotes() { if [[ $LBUFFER[-1] == \' ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
magic-double-quotes() { if [[ $LBUFFER[-1] == \" ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
magic-parentheses() { if [[ $LBUFFER[-1] == \( ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
magic-square-brackets() { if [[ $LBUFFER[-1] == \[ ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
magic-curly-brackets() { if [[ $LBUFFER[-1] == \{ ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
magic-angle-brackets() { if [[ $LBUFFER[-1] == \< ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
bindkey \' magic-single-quotes
bindkey \" magic-double-quotes
bindkey \) magic-parentheses
bindkey \] magic-square-brackets
bindkey \} magic-curly-brackets
bindkey \> magic-angle-brackets
zle -N magic-single-quotes
zle -N magic-double-quotes
zle -N magic-parentheses
zle -N magic-square-brackets
zle -N magic-curly-brackets
zle -N magic-angle-brackets

# Show what the completion system is trying to complete with at a given point
bindkey '$key_info[Control]Xh' _complete_help

bindkey " " magic-space
