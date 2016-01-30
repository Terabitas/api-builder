#!/usr/bin/env bash

# Note that this will automagically be ran if you have rvm installed.
# This shell file sets up the following aliases whenever you cd into
# the current directory tree:
#
# + quayBuilder
# + localBuilder
#
# If rvm is not installed then you can simply run:
#   . setup.sh
#
# Note that these aliases revert back to executing the system version
# of each command whenever you exit the current project dir tree.

PREV_ROOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

function quayBuilder() {
	if [[ $PWD/ = $PREV_ROOT_DIR/* ]]; then
		docker run --rm --net=host -v "/var/run/docker.sock:/var/run/docker.sock" quay.io/nildev/base_builder:latest $@
	else
		`which quayBuilder` $@
	fi
}

function localBuilder() {
	if [[ $PWD/ = $PREV_ROOT_DIR/* ]]; then
		docker run --rm --net=host -v "/var/run/docker.sock:/var/run/docker.sock" nildev/base_builder:latest $@
	else
		`which localBuilder` $@
	fi
}

