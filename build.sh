#!/bin/bash -e

source /env.sh

# Code gen
# ... all magic happens here ...
/go/bin/nildev io --sourceDir=$pkgPathService
cd $pkgPathService
/go/bin/godep save -r ./...
/go/bin/goimports -w .
git add .
git commit -m"Auto"
cat gen_init.go

/go/bin/nildev r --services=$1 --containerDir=$pkgPathContainer
cd $pkgPathContainer
/go/bin/godep save -r ./...
/go/bin/goimports -w ./gen
git add .
git commit -a -m"Auto"
cat gen/gen_init.go

# Compile statically linked version of package
echo "Building [$1] within [$2]"

cd $pkgPathContainer
`CGO_ENABLED=${CGO_ENABLED:-0} go build -a --installsuffix cgo --ldflags="${LDFLAGS:--s}" $2`

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
