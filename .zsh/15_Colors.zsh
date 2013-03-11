# -*- mode: sh;-*-

# set colors for use in prompts (modern zshs allow for the use of %F{red}foo%f
# in prompts to get a red "foo" embedded, but it's good to keep these for
# backwards compatibility).
if zrcautoload colors && colors 2>/dev/null ; then
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval BOLD_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
        eval $color='%{$fg[${(L)color}]%}'
        (( count = $count + 1 ))
    done
    NO_COLOR="%{${reset_color}%}"
else
    BLUE=$'%{\e[1;34m%}'
    RED=$'%{\e[1;31m%}'
    GREEN=$'%{\e[1;32m%}'
    CYAN=$'%{\e[1;36m%}'
    WHITE=$'%{\e[1;37m%}'
    MAGENTA=$'%{\e[1;35m%}'
    YELLOW=$'%{\e[1;33m%}'
    NO_COLOR=$'%{\e[0m%}'
fi
