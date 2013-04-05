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

# Make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-smkx () {
        emulate -L zsh
        printf '%s' ${terminfo[smkx]}
    }
    function zle-rmkx () {
        emulate -L zsh
        printf '%s' ${terminfo[rmkx]}
    }
    function zle-line-init () {
        zle-smkx
    }
    function zle-line-finish () {
        zle-rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# First set it back to known defaults
bindkey -d

# now, our main map is the emacs style
bindkey -e

# First we define widgets that we later bind to keys
# This depends on a zle widget by Max Mikhanosha which he posted to
# zsh-users at http://www.zsh.org/mla/users/2008/msg00708.html
define-pipe-widget insert_grep  "grep \"@@@\"" "grep -i \"@@@\"" "grep -v \"@@@\"" "grep @@@"
define-pipe-widget insert_head "head" "head\n"
define-pipe-widget insert_less "less @@@" "less\n"

zle -N beginning-of-somewhere beginning-or-end-of-somewhere
zle -N end-of-somewhere beginning-or-end-of-somewhere

zle -N insert-datestamp
zle -N sudo-command-line
zle -N jump_after_first_word
zle -N inplaceMkDirs
zle -N magic-single-quotes
zle -N magic-double-quotes
zle -N magic-parentheses
zle -N magic-square-brackets
zle -N magic-curly-brackets
zle -N magic-angle-brackets
# Magic history searching
zle -N predict-on
zle -N slash-backward-kill-word
zle -N insert-files
zle -N insert-unicode-char
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history

accept-line


bind2maps emacs             -- Home      beginning-of-somewhere
bind2maps       viins vicmd -- Home      vi-beginning-of-line
bind2maps emacs             -- End       end-of-somewhere
bind2maps       viins vicmd -- End       vi-end-of-line
bind2maps emacs viins       -- Insert    overwrite-mode
bind2maps             vicmd -- Insert    vi-insert
bind2maps emacs             -- Delete    delete-char
bind2maps       viins vicmd -- Delete    vi-delete-char
bind2maps emacs viins vicmd -- Up        up-line-or-search
bind2maps emacs viins vicmd -- Down      down-line-or-search
bind2maps emacs             -- Left      backward-char
bind2maps       viins vicmd -- Left      vi-backward-char
bind2maps emacs             -- Right     forward-char
bind2maps       viins vicmd -- Right     vi-forward-char
bind2maps       viins vicmd -- Right     vi-forward-char
bind2maps emacs             -- Backspace backward-delete-char
bind2maps       viins vicmd -- Backspace vi-backward-delete-char

# Setup some more bindings to be more like emacs.
bind2maps emacs             -- -s "$key_info[Escape]b"                emacs-backward-word
bind2maps viins vicmd       -- -s "$key_info[Escape]b"                vi-backward-word
bind2maps emacs             -- -s "$key_info[Escape]f"                emacs-forward-word
bind2maps viins vicmd       -- -s "$key_info[Escape]f"                vi-forward-word
bind2maps emacs             -- -s "$key_info[Escape]$key_info[Left]"  emacs-backward-word
bind2maps emacs             -- -s "$key_info[Escape]$key_info[Right]" emacs-forward-word
#k# Kill to the beginning of the line.
bind2maps emacs viins vicmd -- -s "$key_info[Escape]k"                backward-kill-line
#k# Redo.
bind2maps emacs             -- -s "$key_info[Escape]_"                redo
#k# suspend current line
bind2maps emacs viins vicmd -- -s "$key_info[Control]z"               push-input
#k# Bind Shift + Tab to go to the previous menu item.
bind2maps emacs viins vicmd -- -s "$key_info[BackTab]"                reverse-menu-complete
#k# Insert a timestamp on the command line (yyyy-mm-dd)
bind2maps emacs viins       -- -s "$key_info[Control]ed"              insert-datestamp
#k# Append grep, multiple toggle options
bind2maps emacs viins       -- -s "$key_info[Control]g"               insert_grep
#k# Append head, multiple execute
bind2maps emacs viins       -- -s "$key_info[Control]h"               insert_head
#k# Append less, multiple execute
bind2maps emacs viins       -- -s "$key_info[Control]f"               insert_less
#k# Put the current command line into a \kbd{sudo} call
bind2maps emacs viins       -- -s "$key_info[Control]os"              sudo-command-line
#k# Copy the previous shell word - magic to rename files
bind2maps emacs viins       -- -s "$key_info[Escape]m"                copy-prev-shell-word
#k# mkdir -p <dir> from string under cursor or marked area
bind2maps emacs viins       -- -s "$key_info[Control]xM"              inplaceMkDirs
#k# Show what the completion system is trying to complete with at a given point
bind2maps emacs viins       -- -s "$key_info[Control]Xh"              _complete_help
bind2maps emacs viins       -- -s ' '                                 magic-space
#k# Kill left-side word or everything up to next slash
bind2maps emacs viins       -- -s "$key_info[Escape]v"                slash-backward-kill-word
#k# Kill left-side word or everything up to next slash
bind2maps emacs viins       -- -s "$key_info[Escape]$key_info[Backspace]" slash-backward-kill-word
#k# Kill left-side word or everything up to next slash
bind2maps emacs viins       -- -s "$key_info[Escape]$key_info[Delete]" slash-backward-kill-word
#k# Trigger menu-complete
bind2maps emacs viins       -- -s '\ei' menu-complete  # menu completion via esc-i
#k# jump to after first word (for adding options)
bind2maps emacs viins       -- -s '^x1' jump_after_first_word
#k# complete word from history with menu
bind2maps emacs viins       -- -s "^x^x" hist-complete
# insert unicode character
# usage example: 'ctrl-x i' 00A7 'ctrl-x i' will give you an <A7>
# See for example http://unicode.org/charts/ for unicode characters code
#k# Insert Unicode character
bind2maps emacs viins       -- -s '^xi' insert-unicode-char


#k# Insert files and test globbing
is4 && bind2maps emacs viins -- -s "$keyinfo[Control]Xf"              insert-files
#k# Edit the current line in \kbd{\$EDITOR}
is4 && bind2maps emacs viins -- -s "$key_info[Control]x$key_info[Control]e" edit-command-line
#k# Magic history searching
is4 && bind2maps emacs viins -- -s "$key_info[Control]X$key_info[Control]R" predict-on
    #bindkey "^U" predict-off ## C-u

bind2maps emacs viins vicmd -- -s \'                                  magic-single-quotes
bind2maps emacs viins vicmd -- -s \"                                  magic-double-quotes
bind2maps emacs viins vicmd -- -s \)                                  magic-parentheses
bind2maps emacs viins vicmd -- -s \]                                  magic-square-brackets
bind2maps emacs viins vicmd -- -s \}                                  magic-curly-brackets
bind2maps emacs viins vicmd -- -s \>                                  magic-angle-brackets
