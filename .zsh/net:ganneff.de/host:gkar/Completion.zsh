# -*- mode: sh;-*-

# In addition to what we have globally
_hostdescs_debconf=(${${${${(f)"$(<$HOME/.hostdesc.debconf)"}:#[\|]*}%%\ *}%%,*})
_hostdescs_ganneff=(${${${${(f)"$(<$HOME/.hostdesc.ganneff)"}:#[\|]*}%%\ *}%%,*})
_hostdescs_ilo=(${${${${(f)"$(<$HOME/.hostdesc.ilo)"}:#[\|]*}%%\ *}%%,*})
_hostdescs_nsb=(${${${${(f)"$(<$HOME/.hostdesc.nsb)"}:#[\|]*}%%\ *}%%,*})
_hostdescs_oftc=(${${${${(f)"$(<$HOME/.hostdesc.oftc)"}:#[\|]*}%%\ *}%%,*})
_hostdescs_other=(${${${${(f)"$(<$HOME/.hostdesc.other)"}:#[\|]*}%%\ *}%%,*})
_hostdescs_spi=(${${${${(f)"$(<$HOME/.hostdesc.spi)"}:#[\|]*}%%\ *}%%,*})

hosts=(
    ${HOST}
    "$_ssh_hosts[@]"
    "$_ssh_debian_hosts[@]"
    "$_ssh_etc_hosts[@]"
    "$_etc_hosts[@]"
    "$_hostdesc_debconf[@]"
    "$_hostdesc_ganneff[@]"
    "$_hostdesc_ilo[@]"
    "$_hostdesc_nsb[@]"
    "$_hostdesc_oftc[@]"
    "$_hostdesc_other[@]"
    "$_hostdesc_spi[@]"
    localhost
)
zstyle ':completion:*:hosts' hosts $hosts
