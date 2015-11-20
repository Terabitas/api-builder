#!/bin/bash

serviceToBuild=$1
containerToBuild=$2
tagName=$3

# Grab just first path listed in GOPATH
goPath="${GOPATH%%:*}"

# For private repos
git config --global url."git@bitbucket.org:".insteadOf "https://bitbucket.org/"

# Fetch service to build
go get -d $serviceNameToBuild
go get -d $containerToBuild

# Construct Go package path
pkgPathService="$goPath/src/$serviceToBuild"
pkgPathContainer="$goPath/src/$containerToBuild"

if [ -e "$pkgPathService/Godeps/_workspace" ];
then
  # Add local godeps dir to GOPATH
  GOPATH=$pkgPathService/Godeps/_workspace:$GOPATH
fi

if [ -e "$pkgPathContainer/Godeps/_workspace" ];
then
  # Add local godeps dir to GOPATH
  GOPATH=$pkgPathContainer/Godeps/_workspace:$GOPATH
fi