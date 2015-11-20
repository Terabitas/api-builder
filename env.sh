#!/bin/bash

tagName=$1

# Grab just first path listed in GOPATH
goPath="${GOPATH%%:*}"

# For private repos
git config --global url."git@bitbucket.org:".insteadOf "https://bitbucket.org/"

if ( find /src/service -maxdepth 0 -empty | read v );
then
  echo "Error: Must mount Service source code into /src/service directory"
  exit 990
fi

if ( find /src/container -maxdepth 0 -empty | read v );
then
  echo "Error: Must mount Service Container source code into /src/container directory"
  exit 990
fi

# Grab Go package name
cd /src/service
pkgNameService="$(go list -e -f '{{.ImportComment}}' 2>/dev/null || true)"

cd /src/container
pkgNameContainer="$(go list -e -f '{{.ImportComment}}' 2>/dev/null || true)"

if [ -z "$pkgNameService" ];
then
  echo "Error: Must add canonical import path to root package of /src/service"
  exit 992
fi

if [ -z "$pkgNameContainer" ];
then
  echo "Error: Must add canonical import path to root package of /src/container"
  exit 992
fi

# Construct Go package path
pkgPathService="$goPath/src/$pkgNameService"
pkgPathContainer="$goPath/src/$pkgNameContainer"

# Set-up src directory tree in GOPATH
mkdir -p "$(dirname "$pkgPathService")"
mkdir -p "$(dirname "$pkgPathContainer")"

# Link source dirs into GOPATH
ln -sf /src/service "$pkgPathService"
ln -sf /src/container "$pkgPathContainer"

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