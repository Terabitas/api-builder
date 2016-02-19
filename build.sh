#!/bin/bash -e

source /env.sh

# Code gen
# ... all magic happens here ...
/go/bin/nildev io --sourceDir=$pkgPathService
cd $pkgPathService
git add --all .
git commit -m"Auto"
/go/bin/godep save ./...
/go/bin/goimports -w .
git add --all .
git commit -m"Auto"
cat gen_init.go

/go/bin/nildev r --services=$1 --containerDir=$pkgPathContainer
cd $pkgPathContainer
git add --all .
git commit -m"Auto"
/go/bin/godep save ./...
/go/bin/goimports -w ./gen
git add --all .
git commit -a -m"Auto"
cat gen/gen_init.go

# Compile statically linked version of package
echo "Building [$1] within [$2]"

cd $pkgPathContainer

CGO_ENABLED=0 go build -a --installsuffix cgo -ldflags "-s -X main.Version=`git rev-parse --abbrev-ref HEAD` -X main.GitHash=`git rev-parse HEAD` -X main.BuiltTimestamp=`date -u '+%Y-%m-%d_%I:%M:%S%p'`" $2

# Grab the last segment from the package name
name=${1##*/}

if [[ $COMPRESS_BINARY == "true" ]];
then
  goupx $name
fi

if [ -e "/var/run/docker.sock" ] && [ -e "$pkgPathContainer/Dockerfile" ];
then
  cd $pkgPathContainer

  # Default TAG_NAME to package name if not set explicitly
  tagName=${tagName:-"$name":latest}

  # Build the image from the Dockerfile in the package directory
  docker build -t $3 .
fi
