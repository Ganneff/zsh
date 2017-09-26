### vim:ft=zsh
### directory-dependent environment configuration
# https://github.com/aptituz/zsh/blob/master/directory-based-environment-configuration
# Copyright (C) 2011 by Patrick Schoenfeld <patrick.schoenfeld@googlemail.com>
# License: GPL v2
# (some parts taken from the grml zshrc)
#
# This shell functions allow to switch environment variables / profiles based
# on directory names. It allows a configuration similar to the following:
# 
# # Define ENVIRONMENTS
# ENV_TEST1=(
#     "EMAIL"             "foo@bar.com"
# )
# 
# ENV_TEST2=(
#     "EMAIL"             "foo@baz.com"
# )
# 
# ENV_DEFAULT=(
#     "EMAIL"             "$EMAILS[private]"
#     "DEBEMAIL"          "$EMAILS[debian]"
#     "GIT_AUTHOR_EMAIL"  "$EMAILS[private]"
# )
# 
# # Configure profile mappings
# zstyle ':chpwd:profiles:/home/foo/workspace/test1*' profile test1
# zstyle ':chpwd:profiles:/home/foo/workspace/test2*' profile test2
#
# It requires to add a chpwd function or extend it:
#
# function chpwd() {
#   ...
#   switch_environment_profiles
#   ...
# }
#
# This will set the environment variable EMAIL to different values, depending
# on the directory in which you are.
#
# Additionally its possible to have hook functions associated to a profile.
# Just define functions similar to the following:
#
# function chpwd_profile_PROFILE() {
#   print "This is a hook for the PROFILE profile
# }

function detect_env_profile {
    local profile
    zstyle -s ":chpwd:profiles:${PWD}" profile profile || profile='default'
    profile=${(U)profile}
    if [ "$profile" != "$ENV_PROFILE" ]; then
        print "Switching to profile: $profile"
    fi

    ENV_PROFILE="$profile"
}

function switch_environment_profiles {
    detect_env_profile
    config_key="ENV_$ENV_PROFILE"
    for key value in ${(kvP)config_key}; do
        export $key=$value
    done

    # Taken from grml zshrc, allow chpwd_profile_functions()
    if (( ${+functions[chpwd_profile_$ENV_PROFILE]} )) ; then
        chpwd_profile_${ENV_PROFILE}
    fi
}