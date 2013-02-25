# -*- mode: sh;-*-

export DAK_INSPECT_UPLOAD='tmux new-session -d -s process-new 2>/dev/null; tmux new-window -t process-new:1 -n "${changes}" -k " cd {directory}; mc"'
alias lisa='dak process-new'
alias melanie='dak rm'
alias helena='dak queue-report'
alias alicia='dak override'
alias rosamund='dak find-null-maintainers'
alias emilie='dak import-ldap-fingerprints'
alias saffron='dak stats'
alias madison='dak ls'
alias natalie='dak control-overrides'
