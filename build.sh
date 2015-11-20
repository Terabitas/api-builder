#!/bin/bash -e

source env.sh

# Code gen
# ... all magic happens here ...
/go/bin/nildev io --sourceDir=$pkgPathService
/go/bin/nildev r --services=$pkgNameService --containerDir=$pkgPathContainer

# Compile statically linked version of package
echo "Building $pkgNameService within $pkgNameContainer"

cd /src/container
`CGO_ENABLED=${CGO_ENABLED:-0} go build -a --installsuffix cgo --ldflags="${LDFLAGS:--s}" $pkgNameContainer`

# Grab the last segment from the package name
name=${pkgNameService##*/}

if [[ $COMPRESS_BINARY == "true" ]];
then
  goupx $name
fi

if [ -e "/var/run/docker.sock" ] && [ -e "/src/container/Dockerfile" ];
then
  cd /src/container

  # Default TAG_NAME to package name if not set explicitly
  tagName=${tagName:-"$name":latest}

  # Build the image from the Dockerfile in the package directory
  docker build -t $tagName .
fi