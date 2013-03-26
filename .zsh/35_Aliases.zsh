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

alias mv='command mv -i'
alias mmv='noglob mmv'
alias cp='command cp -i'
alias wget='noglob wget'
alias cgrep='grep --color'
alias git='LANG=C git'
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

is-callable psql && alias psql='LD_PRELOAD=/lib/libreadline.so.5 psql'

alias logout='noglob logout'

# want to trace a shell function? ztrace $FUNCTIONNAME and there it goes.
alias ztrace='typeset -f -t'
alias zuntrace='typeset -f +t'

# overwrite cal
alias cal='cal -3'

# convenient abbreviations
alias c=clear

alias d='dirs -v'

alias cd/='cd /'
alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias -- -='cd -'
for index ({1..9}) alias "$index"="cd -${index}"; unset index

alias mc='mc -d -U'
alias cpan='perl -MCPAN -e shell'
alias rh='run-help'

# No spellchecks here
alias man='LANG=C nocorrect noglob man'
alias mysql='nocorrect mysql'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'

#global aliases. Handle with care!
alias -g LS='| less'
alias -g WC='| wc -l'
alias -g SO='| sort'
alias -g CD='| colordiff | less -R'

if [ -x /usr/bin/recode ]; then
    alias unix2dos='recode lat1..ibmpc'
    alias dos2unix='recode ibmpc..lat1'
fi

# used when you press M-? on a command line
alias which-command='whence -a'

# zsh function tracing
alias ztrace='typeset -f -t'
alias zuntrace='typeset -f +t'

alias gitolite_spi='ssh git@git.spi-inc.org'

# Make popd changes permanent without having to wait for logout
if zstyle -T ':ganneff:config' dirstackhandling dirpersist dirstack; then
    alias popd="popd;dirpersiststore"
fi

# git related
# Aliases
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gup='git pull --rebase'
alias gp='git push'
alias gd='git diff'
alias gdc='git diff --cached'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gco='git checkout'
alias gcm='git checkout master'
alias gr='git remote'
alias grv='git remote -v'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grup='git remote update'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcl='git config --list'
alias gcp='git cherry-pick'
alias glg='git log --stat --max-count=5'
alias glgg='git log --graph --max-count=5'
alias glgga='git log --graph --decorate --all'
alias gss='git status -s'
alias ga='git add'
alias gm='git merge'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias gwc='git whatchanged -p --abbrev-commit --pretty=medium'
alias gf='git ls-files | grep'
alias gpoat='git push origin --all && git push origin --tags'
alias gg='git grep'

# Will cd into the top of the current repository
# or submodule.
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'

alias gsr='git svn rebase'
alias gsd='git svn dcommit'

# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
current_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
    echo ${ref#refs/heads/}
}

current_repository() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
    echo $(git remote -v | cut -d':' -f 2)
}

# these aliases take advantage of the previous function
alias ggpull='git pull origin $(current_branch)'
alias ggpush='git push origin $(current_branch)'
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
