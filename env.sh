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

# Construct path to mounted src for local builds
localPkgPathService="/src/$1"
localPkgPathContainer="/src/$2"

# Fetch service or copy from mounted dir to build
if [ ! -d "$localPkgPathService" ]; then
    echo "Get $1"
    go get -d $1
else
    mkdir -p $pkgPathService
    cp -R $localPkgPathService/. $pkgPathService/
    echo "$localPkgPathService copy to $pkgPathService"
fi
cd $pkgPathService
/go/bin/godep restore

if [ ! -d "$localPkgPathContainer" ]; then
    echo "Get $2"
    go get -d $2
else
    mkdir -p $pkgPathContainer
    cp -r $localPkgPathContainer/. $pkgPathContainer/
    echo "$localPkgPathContainer copy to $pkgPathContainer"
fi
cd $pkgPathContainer
/go/bin/godep restore