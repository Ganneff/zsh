# -*- mode: sh;-*-

# default switches
if ls --help 2>/dev/null | grep -q GNU; then
    alias ls='command ls -AF --color=auto'
elif isdarwin || isfreebsd; then
    alias ls='command ls -AF -G'
fi

alias lsbig='command ls -flh *(.OL[1,10])' # display the biggest files
alias lssmall='command ls -Srl *(.oL[1,10])' # display the smallest files
alias lsnew='command ls -rl *(D.om[1,10])' # display the newest files
alias lsold='command ls -rtlh *(D.om[-11,-1])' # display the oldest files

if zstyle -T ':ganneff:config' safemvcp false; then
    alias mv='nocorrect command mv'
    alias cp='nocorrect command cp'
else
    alias mv='nocorrect command mv -i'
    alias cp='nocorrect command cp -i'
fi
# Number of aliases for commands we don't want to do globbing usually
alias wget='noglob wget'
alias scp='noglob scp'

# No spellchecks for these
alias man='nocorrect noglob man'
alias mysql='nocorrect mysql'
alias mkdir='nocorrect mkdir'

# want to trace a shell function? ztrace $FUNCTIONNAME and there it goes.
#a# trace a shell function
alias ztrace='typeset -f -t'
#a# no longer trace a shell function
alias zuntrace='typeset -f +t'

# overwrite cal
alias cal='cal -3'

# convenient abbreviations
alias c=clear
alias d='dirs -v'

# Various little cd helpers
alias cd/='cd /'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias -- -='cd -'
for index ({1..9}) alias "$index"="cd -${index}"; unset index

# various
alias cgrep='grep --color'
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
is-command mc && alias mc='mc -d -U'
alias cpan='perl -MCPAN -e shell'
alias rh='run-help'

if [ -x /usr/bin/recode ]; then
    alias unix2dos='recode lat1..ibmpc'
    alias dos2unix='recode ibmpc..lat1'
fi

# used when you press M-? on a command line
alias which-command='whence -a'

# Make popd changes permanent without having to wait for logout
if zstyle -T ':ganneff:config' dirstackhandling dirpersist dirstack; then
    alias popd="popd;dirpersiststore"
fi

# git related
# Aliases
alias g='git'

# branch related
#a# git branch base
alias gb='git branch'
#a# create a branch and switch to it
alias gbc='git checkout -b'
#a# show details for git branches
alias gbl='git branch -v'
#a# show details for git branches incl. remotes
alias gba='git branch -av'
#a# delete git branch
alias gbd='git branch -d'
#a# Move/rename a branch
alias gbm='git branch -m'

# add
#a# add changes to index
alias ga='git add'
#a# add changes, interactively choose hunks to add
alias gap='git add --patch'
#a# add changes, only files already in the indey
alias gau='git add --update'


# commit
#a# commit changes in git
alias gc='git commit -v'
#a# amend last git commit
alias gca='git commit -v --amend'

# push
#a# push changes
alias gp='git push'
#a# push everything to origin
alias gpoat='git push origin --all && git push origin --tags'

# fetch/clone/pull
#a# fetch and merge from another repository (pull)
alias gl='git pull'
#a# fetch and rebase from another repository
alias gup='git pull --rebase'
#a# fetch another repository
alias gf='git fetch'
#a# clone another repository
alias gcl='git clone'

# checkout
#a# checkout a branch
alias gco='git checkout'
#a# switch to the master branch
alias gcm='git checkout master'

# merge
#a# merge
alias gm='git merge'
#a# merge, but don't commit
alias gmn='git merge --no-ff --no-commit'

# diff
#a# Show changes in the working tree
alias gd='git diff'
#a# Show changes in the index
alias gdc='git diff --cached'
#a# Show logs with differences each commit introduces
alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'

alias gcs='git show'

# log
#a# Show 10 latest commit logs
alias glg='git log --stat --max-count=10'
#a# Show 10 latest commit logs with a text-based graph
alias glgg='git log --graph --max-count=10'
#a# Show all commits with a text-based graph
alias glgga='git log --graph --decorate --all'

# various
#a# revert a commit
alias gcr='git revert'
#a# cherry-pick
alias gcp='git cherry-pick'

#a# reset HEAD
alias grh='git reset HEAD'
#a# reset HEAD discarding all changes to tracked files
alias grhh='git reset HEAD --hard'

#a# show working tree status
alias gst='git status'


#a# run git grep
alias gg='git grep'


# informational
#a# list commit count summary
alias gcount='git shortlog -sn'




# remotes
#a# list remotes
alias gr='git remote'
#a# list remotes including their fetch/push details
alias grv='git remote -v'
alias grmv='git remote rename'
alias grrm='git remote remove'

# Will cd into the top of the current repository
# or submodule.
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'


## global aliases. Handle with care!
alias -g LS='| less'
alias -g LL="|& less"
alias -g WC='| wc -l'
alias -g SO='| sort'
alias -g CD='| colordiff | less -R'
alias -g NE="2> /dev/null"
