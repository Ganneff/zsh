# -*- sh -*-

autoload colors ; colors

# Install or update my ZSH config on a remote host.
# Needs Git and makeself locally
install-zsh() {
    local remote
    local work
    local start
    remote=$1
    work=$(mktemp -d)
    start=$(pwd)
    {
	    local OK="$fg_bold[green]OK.${reset_color}"
	    print -n "$fg[green]Building archive...${reset_color} "
	    #cd $ZSH 
        vcsh run zsh git archive HEAD | tar -C $work -xf -
        mkdir -p $work/zsh-syntax-highlighting
        cd $ZSH/zsh-syntax-highlighting 
        git archive HEAD | tar -C $work/zsh-syntax-highlighting -xf -
	    cp $HOME/.zshenv $work/zshenv.home
        print $OK
	    print -n "$fg[green]Building installer...${reset_color} "
	    makeself --gzip $work $ZSH/zsh-install.sh \
	        "$USER ZSH config files" zsh ./install.zsh MAGIC
	    print $OK
	    [[ -z $1 ]] || {
	        print "$fg[green]Remote install...${reset_color} "
	        scp $ZSH/zsh-install.sh ${remote}:
	        ssh $remote sh ./zsh-install.sh
	        print $OK
	    }
    } always {
	    rm -rf $work
        cd $start
    }
}

# We can be executed to install ourself to the final destination
if [[ $1 == "MAGIC" ]]; then
    (( $+commands[rsync] )) || {
	    print "$fg_bold[red]rsync not found, install it${reset_color}"
	    exit 2
    }
    local OK="$fg[green]OK.${reset_color}"

    # Migrate history
    print -n "$fg[green]History migration...${reset_color} "
    mkdir -p ~/.zsh/var/dirhist
    mkdir -p ~/.zsh/.zcompcache
    { mv ~/.zsh_history ~/.zsh/var/history.$USER.$HOST } 2> /dev/null
    print $OK
    print "$fg[green]Installation of zsh files...${reset_color} "
    rsync -rlp --exclude=var/ --exclude=.zcompcache/ --delete . ~/.zsh/.
    rm -f ~/.zlogin
    rm -f ~/.zlogout
    rm -f ~/.zshrc
    rm -f ~/.zshenv
    ln -s .zsh/zshenv.home ~/.zshenv
    print $OK
    print "$fg[green]Disabling old udh cronjob...${reset_color} "
    crontab -l|sed -e 's_\(#\?[0-9][0-9] [/6*]* \* \* \* $HOME/bin/udh >/dev/null\)_#off#\1_'|crontab
    print $OK
fi
