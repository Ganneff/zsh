# -*- mode: sh;-*-

## Zsh options
#
# see man zshoptions(1) for more details ;-)
#

function SetOPT() {
	SetOPTifExists $1 on
}
function UnsetOPT() {
	SetOPTifExists $1 off
}

function SetOPTifExists() {
	local option=${(L)1//_/} # lowercase and no '_'

    if [[ -n ${options[$option]} ]]; then
		# option exists, set it.
		case "$2" in
			on)
				debug "$fg_bold[cyan]setopt$reset_color $option"
				setopt $option
				;;
			off)
				debug "$fg_bold[cyan]unsetopt$reset_color $option"
				unsetopt $option
				;;
		esac
	else
	    debug "$option not supported by this version of zsh !"
	fi
}

# These are the options that apply to noninteractive shells.
# Ones in capitals are variations from the default ZSH behaviour.

# Treat the `#', `~' and `^' characters as part of patterns for filename
# generation, etc.  (An initial unquoted `~' always produces named
# directory expansion.)
SetOPT	 EXTENDED_GLOB

# Do not require a leading `.' in a filename to be matched explicitly.
SetOPT	 GLOBDOTS

# If numeric filenames are matched by a filename generation pattern,
# sort the filenames numerically rather than lexicographically.
SetOPT	 NUMERIC_GLOB_SORT

# Don't push multiple copies of the same directory onto the directory
# stack.
SetOPT	 PUSHD_IGNORE_DUPS

# Exchanges the meanings of `+' and `-' when used with a number to
# specify a directory in the stack.
SetOPT	 PUSHD_MINUS

# Do not print the directory stack after pushd or popd.
SetOPT	 PUSHDSILENT

# Have pushd with no arguments act like `pushd $HOME'.
SetOPT	 PUSHDTOHOME

# If a completion is performed with the cursor within a word, and a full
# completion is inserted, the cursor is moved to the end of the word.
# That is, the cursor is moved to the end of the word if either a single
# match is inserted or menu completion is performed.
SetOPT   ALWAYS_TO_END

# If a command is issued that can't be executed as a normal command, and
# the command is the name of a directory, perform the cd command to that
# directory.
SetOPT   AUTO_CD

# Any parameter that is set to the absolute name of a directory
# immediately becomes a name for that directory, that will be used by
# the `%~' and related prompt sequences, and will be available when
# completion is performed on a word starting with `~'.  (Otherwise, the
# parameter must be used in the form `~param' first.)
SetOPT   AUTO_NAME_DIRS

# Make cd push the old directory onto the directory stack.
SetOPT   AUTO_PUSHD

# Treat single word simple commands without redirection as candidates
# for resumption of an existing job.
SetOPT   AUTO_RESUME

# Expand expressions in braces which would not otherwise undergo brace
# expansion to a lexically ordered list of all the characters.  See the
# section `Brace Expansion'.
SetOPT   BRACE_CCL

# Prevents aliases on the command line from being internally substituted
# before completion is attempted.  The effect is to make the alias a
# distinct command for completion purposes.
SetOPT   COMPLETE_ALIASES

# If unset, the cursor is set to the end of the word if completion is
# started. Otherwise it stays there and completion is done from both
# ends.
SetOPT   COMPLETE_IN_WORD

# Try to correct the spelling of commands.  Note that, when the
# HASH_LIST_ALL option is not set or when some directories in the path
# are not readable, this may falsely report spelling errors the first
# time some commands are used.
#
# The shell variable CORRECT_IGNORE may be set to a pattern to match
# words that will never be offered as corrections.
SetOPT   CORRECT

# Do not enter command lines into the history list if they are
# duplicates of the previous event.
SetOPT   HIST_IGNORE_DUPS

# If a new command line being added to the history list duplicates an
# older one, the older command is removed from the list (even if it is
# not the previous event).
SetOPT   HIST_IGNORE_ALL_DUPS

# Remove the history (fc -l) command from the history list when invoked.
# Note that the command lingers in the internal history until the next
# command is entered before it vanishes, allowing you to briefly reuse
# or edit the line.
SetOPT   HIST_NO_STORE

# Remove superfluous blanks from each command line being added to the
# history list.
SetOPT   HIST_REDUCE_BLANKS

# This options works like APPEND_HISTORY except that new history lines
# are added to the $HISTFILE incrementally (as soon as they are
# entered), rather than waiting until the shell exits.  The file will
# still be periodically re-written to trim it when the number of lines
# grows 20% beyond the value specified by $SAVEHIST (see also the
# HIST_SAVE_BY_COPY option).
SetOPT	 INC_APPEND_HISTORY

# When searching for history entries in  the line editor, do not display
# duplicates of a line previously found,  even if the duplicates are not
# contiguous.
SetOPT	 HIST_FIND_NO_DUPS

# Remove command lines from the history list when the first character on
# the line is a space, or when one of the expanded aliases contains a
# leading space.  Only normal aliases (not global or suffix aliases)
# have this behaviour.  Note that the command lingers in the internal
# history until the next command is entered before it vanishes, allowing
# you to briefly reuse or edit the line.  If you want to make it vanish
# right away without entering another command, type a space and press
# return.
SetOPT	 HIST_IGNORE_SPACE

# Allow comments even in interactive shells.
SetOPT   INTERACTIVE_COMMENTS

# List jobs in the long format by default.
SetOPT   LONG_LIST_JOBS

# If set, parameter expansion, command substitution and arithmetic
# expansion are performed in prompts. Substitutions within prompts do
# not affect the command status.
SetOPT   PROMPT_SUBST

# If the internal history needs to be trimmed to add the current command
# line, setting this option will cause the oldest history event that has
# a duplicate to be lost before losing a unique event from the list.
# You should be sure to set the value of HISTSIZE to a larger number
# than SAVEHIST in order to give you some room for the duplicated
# events, otherwise this option will behave just like
# HIST_IGNORE_ALL_DUPS once the history fills up with unique events.
SetOPT   HIST_EXPIRE_DUPS_FIRST

# Try to make the completion list smaller (occupying less lines) by
# printing the matches in columns with different widths.
SetOPT   LIST_PACKED

# This option both imports new commands from the history file, and also
# causes your typed commands to be appended to the history file (the
# latter is like specifying INC_APPEND_HISTORY).  The history lines are
# also output with timestamps ala EXTENDED_HISTORY (which makes it
# easier to find the spot where we left off reading the file after it
# gets re-written).

# By default, history movement commands visit the imported lines as well
# as the local lines, but you can toggle this on and off with the
# set-local-history zle binding.  It is also possible to create a zle
# widget that will make some commands ignore imported commands, and some
# include them.
is4 && SetOPT   SHARE_HISTORY

# Save each command's beginning timestamp (in seconds since the epoch)
# and the duration (in seconds) to the history file.
SetOPT   EXTENDED_HISTORY

# By default, shell history that is read in from files is split into
# words on all white space.  This means that arguments with quoted
# whitespace are not correctly handled, with the consequence that
# references to words in history lines that have been read from a file
# may be inaccurate.  When this option is set, words read in from a
# history file are divided up in a similar fashion to normal shell
# command line handling.  Although this produces more accurately
# delimited words, if the size of the history file is large this can be
# slow.  Trial and error is necessary to decide.
is4311 && SetOPT HIST_LEX_WORDS

# When writing out the history file, by default zsh uses ad-hoc file
# locking to avoid known problems with locking on some operating
# systems.  With this option locking is done by means of the system's
# fcntl call, where this method is available.  On recent operating
# systems this may provide better performance, in particular avoiding
# history corruption when files are stored on NFS.
SetOPT HIST_FCNTL_LOCK

# Allows `>' redirection to truncate existing files, and `>>' to create
# files.  Otherwise `>!' or `>|' must be used to truncate a file, and
# `>>!' or `>>|' to create a file.
UnsetOPT CLOBBER

# If this option is set, passing the -x flag to the builtins declare,
# float, integer, readonly and typeset (but not local) will also set the
# -g flag; hence parameters exported to the environment will not be made
# local to the enclosing function, unless they were already or the flag
# +g is given explicitly.  If the option is unset, exported parameters
# will be made local in just the same way as any other parameter.
UnsetOPT GLOBAL_EXPORT

# On an ambiguous completion, instead of listing possibilities or
# beeping, insert the first match immediately.  Then when completion
# is requested again, remove the first match and insert the second
# match, etc.  When there are no more matches, go back to the first one
# again.  reverse-menu-complete may be used to loop through the list in
# the other direction. This option overrides AUTO_MENU.
UnsetOPT MENU_COMPLETE

# Beep on error in ZLE.
UnsetOPT BEEP

# If this option is unset, output flow control via start/stop characters
# (usually assigned to ^S/^Q) is disabled in the shell's editor.
UnsetOPT FLOW_CONTROL

# Do not exit on end-of-file.  Require the use of exit or logout
# instead.  However, ten consecutive EOFs will cause the shell to exit
# anyway, to avoid the shell hanging if its tty goes away.

# Also, if this option is set and the Zsh Line Editor is used, widgets
# implemented by shell functions can be bound to EOF (normally
# Control-D) without printing the normal warning message.  This works
# only for normal widgets, not for completion widgets.
UnsetOPT IGNORE_EOF

# Beep on an ambiguous completion.  More accurately, this forces the
# completion widgets to return status 1 on an ambiguous completion,
# which causes the shell to beep if the option BEEP is also set; this
# may be modified if completion is called from a user-defined widget.
UnsetOPT LIST_BEEP

# Remove any right prompt from display when accepting a command line.
# This may be useful with terminals with other cut/paste methods.
is41 && SetOPT TRANSIENT_RPROMPT

# Send the HUP signal to running jobs when the shell exits.
UnsetOPT HUP

# Run all background jobs at a lower priority.
UnsetOPT BG_NICE


unfunction -m SetOPT
unfunction -m UnsetOPT
unfunction -m SetOPTifExists
