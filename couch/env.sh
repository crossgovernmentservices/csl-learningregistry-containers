#!/bin/sh
#
# Activate the environment used by Build CouchDB.
# This script is idempotent and runs silently when not connected to a terminal.

original_under="$_"

this_file="$BASH_SOURCE"
if [ -z "$this_file" ]; then
    this_file="$0"
fi

# Since this script sets the environment, it must be sourced. Since running it
# in a subshell is pointless, detect if that happened and warn the user.
#
# Detection confirmed to work for ./env.sh, . env.sh, source env.sh, $SHELL env.sh for all of:
#  * Bash
#  * Zsh
#  * Dash
if [ $(basename -- "$0") = 'env.sh' ]; then
    err="This script must be sourced, not run standalone"

    if [ "$ZSH_VERSION" ]; then
        # Re-confirm for Zsh since the above test does not work.
        if [ "$original_under" != "$0" ]; then
            echo "$err" >&2
            exit 1
        fi
    else
        echo "$err" >&2
        exit 1
    fi
fi

main () {
    dir_to_path '/opt/couchdb/1.2.2/bin' 'insert' 'PATH'
    export ERL_FLAGS="-pa /opt/couchdb/1.2.2/lib/couchdb/plugins/geocouch/ebin /opt/couchdb/1.2.2/lib/couchdb/plugins/browserid_couchdb/ebin"
}

puts ()
{
    if [ -t 2 ]; then
        echo "$*" >&2
    fi
}

abspath () {
    if [ `uname` = 'Darwin' ]; then
        ruby -e "puts File.expand_path('$1')"
    else
        readlink -f "$1"
    fi
}

# Idempotently add a directory into a search path.
dir_to_path () {
    desired="$1"
    add_type="$2"
    env_var="$3"

    if [ ! -d "$desired" ]; then
        mkdir -p "$desired"
    fi

    desired=`abspath "$desired"`

    # Prefix the path with ':' so grep can confirm the absolute location.
    current_path=`eval "echo :\\$$env_var"`
    if ! echo "$current_path" | grep ":$desired" > /dev/null; then
        if [ "$add_type" = 'insert' ]; then
            puts "Inserting to $env_var: $desired"
            eval "$env_var=\"$desired:\$$env_var\""
        elif [ "$add_type" = 'append' ]; then
            puts "Appending to $env_var: $desired"
            eval "$env_var=\"$env_var:\$$desired\""
        else
            "Woa, what's going on here? $add_type $desired"
        fi

        eval "export $env_var"
    fi
}

main

# Clean up.
unset desired
unset env_var
unset pre_dir
unset post_dir
unset add_type
unset this_file
unset current_path
unset greppable_path
unset original_under

unset main
unset puts
unset abspath
unset to_path

# vim: sts=4 sw=4 et
