#!/bin/bash

serviceToBuild="$1"
containerToBuild="$2"
tagName="$3"

# Grab just first path listed in GOPATH
goPath="${GOPATH%%:*}"

# For private repos
#git config --global url."git@bitbucket.org:".insteadOf "https://bitbucket.org/"
git config --global user.email "go@nildev.io"
git config --global user.name "nildev"

# Construct Go package path
pkgPathService="$goPath/src/$1"
pkgPathContainer="$goPath/src/$2"

# Fetch service to build
echo "Get $1"
go get -d $1
cd $pkgPathService
/go/bin/godep restore

echo "Get $2"
go get -d $2
cd $pkgPathContainer
/go/bin/godep restore