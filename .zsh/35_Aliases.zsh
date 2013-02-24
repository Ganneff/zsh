# -*- mode: sh;-*-

# default switches
alias ls='command ls -AF --color=auto'
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

alias psql='LANG=C LD_PRELOAD=/lib/libreadline.so.5 psql'
alias tmux='TMPDIR=/tmp tmux'

alias logout='noglob logout'

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
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'



alias mc='mc -d -U'
alias showpkg='apt-cache showpkg'
alias acs='apt-cache search'
alias acw='apt-cache show'
alias agi='LANG=C sudo aptitude install'
alias agr='LANG=C sudo aptitude remove'
alias agp='LANG=C sudo aptitude purge'
alias dclean='LANG=C LC_ALL=C fakeroot debian/rules clean'
alias cpan='perl -MCPAN -e shell'

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
alias popd="popd;dirpersiststore"

# git related
# Aliases
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gup='git pull --rebase'
alias gp='git push'
alias gd='git diff'
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
