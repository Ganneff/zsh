# -*- mode: sh;-*-

export DAK_INSPECT_UPLOAD='tmux new-session -d -s process-new 2>/dev/null; tmux new-window -t process-new:1 -n "${changes}" -k " cd {directory}; mc"'
