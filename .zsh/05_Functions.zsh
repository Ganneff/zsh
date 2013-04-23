# -*- mode: sh;-*-

## 	User-defined functions
#
preprint()
{
	local my_color start stop pipe1 pipe2 hbar out

    if [[ "$COLORS" == "true" ]]; then
	    my_color=${2:-${BOLD_RED}}
    else
        my_color=${2:-""}
    fi
    if [[ $LINEDRAW == "true" ]]; then
        # Some stuff to help us draw nice lines
        if isutf8 || isconsole; then
            start=""
            stop=""
            PR_ULCORNER="┌"
            PR_LLCORNER="└"
            PR_LRCORNER="┘"
            PR_URCORNER="┐"
            draw="─"
        else
            start="$terminfo[smacs]"
            stop="$terminfo[rmacs]"
            pipe1="u"
            pipe2="t"
            draw="q"
        fi
    else
        start=""
        stop=""
        pipe1="|"
        pipe2="|"
        draw="-"
    fi
    hbar="${start}${${(l:$(( 74 - ${#1} - 5 ))::X:)}//X/$draw}${stop}"
    out="${my_color}${hbar}${start}"

	if [[ "${1}" != "" ]]; then
        out+="${pipe1}${stop}${my_color} $1 ${my_color}${start}${pipe2}"
    else
        out+="${draw}${draw}"
    fi
    out+="${draw}${stop}${NO_COLOR}\r"

    print -Pn -- $out
}

_jj_chpwd()
{
	if ( is-callable git && test -d .git ); then
		# Shows tracked branches and modified files
		git checkout HEAD 2>&1 | sed 's/^/   /'
	fi
}

# Idea taken from oh-my-zsh, but code is different
function dirpersistrestore () {
    if [ -f ${DIRSTACKFILE} ]; then
        dirstack=( ${(f)"$(< ${DIRSTACKFILE} )"} )
        if zstyle -t ':ganneff:config' dirstackhandling dirpersist; then
            cd -q ${dirstack[-1]}
        fi
    fi
}

function dirpersiststore () {
    print -l ${(Oau)dirstack} ${PWD} >| ${DIRSTACKFILE}
}

function agent() {
    local agent agentfiles af
    local _agent_ssh_env=${HOME}/.ssh/agentenv.${HOST}
    typeset -a agentfiles

    touch ${_agent_ssh_env}
    chmod 0600 ${_agent_ssh_env}

    zstyle -s ':ganneff:config' agent agent || agent=gpg-agent
    case ${agent} in
        gpg-agent)
            if is-callable gpg-agent; then
                eval $(gpg-agent --enable-ssh-support \
                    --daemon \
                    --write-env-file ${_agent_ssh_env})
            else
                print "gpg-agent binary not found"
                return 1
            fi
            ;;
        ssh-agent)
            if is-callable ssh-agent; then
                ssh-agent | sed s'/^echo/#echo/g' >| ${_agent_ssh_env}
                source ${_agent_ssh_env}
            else
                print "ssh-agent binary not found"
                return 1
            fi
            ;;
        *)
            print "Unknown agent ${agent}, not doing anything!"
            ;;
    esac

    zstyle -a ':ganneff:config' agentfiles agentfiles || agentfiles = ()
    for af in ${agentfiles}; do
        ssh-add ${af}
    done

    if is434 && zstyle -T ':ganneff:config' killagent true; then
        add-zsh-hook zshexit kill_agent
    fi
}

function kill_agent() {
    local _agent_ssh_env=${HOME}/.ssh/agentenv.${HOST}
    kill -TERM ${SSH_AGENT_PID}
    rm -f ${_agent_ssh_env}
}

function Status Start Stop Restart Reload {
    typeset script
    for script in ${*}; {
        sudo /etc/init.d/${script} ${0:l}
    }
}

# copied from grml
function zrcgotwidget() {
    (( ${+widgets[$1]} ))
}

# copied from grml
function zrcgotkeymap() {
    [[ -n ${(M)keymaps:#$1} ]]
}

# copied from grml
function zrcbindkey() {
    if (( ARGC )) && zrcgotwidget ${argv[-1]}; then
        bindkey "$@"
    fi
}

# copied from grml
function bind2maps () {
    local i sequence widget
    local -a maps

    while [[ "$1" != "--" ]]; do
        maps+=( "$1" )
        shift
    done
    shift

    if [[ "$1" == "-s" ]]; then
        shift
        sequence="$1"
    else
        sequence="${key_info[$1]}"
    fi
    widget="$2"

    [[ -z "$sequence" ]] && return 1

    for i in "${maps[@]}"; do
        zrcbindkey -M "$i" "$sequence" "$widget"
    done
}

# move cursor between chars when typing '', "", (), [], and {}
magic-single-quotes() { if [[ $LBUFFER[-1] == \' ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
magic-double-quotes() { if [[ $LBUFFER[-1] == \" ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
magic-parentheses() { if [[ $LBUFFER[-1] == \( ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
magic-square-brackets() { if [[ $LBUFFER[-1] == \[ ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
magic-curly-brackets() { if [[ $LBUFFER[-1] == \{ ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
magic-angle-brackets() { if [[ $LBUFFER[-1] == \< ]]; then zle self-insert; zle .backward-char; else zle self-insert; fi };
