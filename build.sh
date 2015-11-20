#!/bin/bash -e

source env.sh

# Code gen
# ... all magic happens here ...
/go/bin/nildev io --sourceDir=$pkgPathService
cd $pkgPathService
/go/bin/godep save -r ./...

/go/bin/nildev r --services=$serviceToBuild --containerDir=$pkgPathContainer
cd $pkgPathContainer
/go/bin/godep save -r ./...

# Compile statically linked version of package
echo "Building [$serviceToBuild] within [$containerToBuild]"

cd $pkgPathContainer
`CGO_ENABLED=${CGO_ENABLED:-0} go build -a --installsuffix cgo --ldflags="${LDFLAGS:--s}" $containerToBuild`

# Grab the last segment from the package name
name=${serviceToBuild##*/}

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
  docker build -t $tagName .
fi