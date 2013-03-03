# -*- mode: sh;-*-

if which ssh-agent >/dev/null; then
    agent() {
        eval $(ssh-agent) >/dev/null
        ssh-add ~/.ssh/id_cole
    }


    _kill_agent() {
        ssh-agent -k
    }
    is434 && add-zsh-hook zshexit _kill_agent
fi
