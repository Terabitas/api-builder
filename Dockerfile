FROM golang:latest
MAINTAINER nildev <steelzz@nildev.io>

RUN apt-get update && apt-get install -y upx-ucl nano
# Install Docker binary
RUN wget -nv https://get.docker.com/builds/Linux/x86_64/docker-1.3.3 -O /usr/bin/docker && \
  chmod +x /usr/bin/docker
RUN go get github.com/pwaller/goupx
RUN go get github.com/tools/godep
RUN go get golang.org/x/tools/cmd/goimports
RUN go get github.com/nildev/tools/cmd/nildev

WORKDIR /go/src

COPY env.sh /
COPY build.sh /

VOLUME ["/src"]

ENTRYPOINT ["/build.sh"]