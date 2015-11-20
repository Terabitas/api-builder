FROM golang:latest
MAINTAINER nildev <steelzz@nildev.io>

RUN apt-get update && apt-get install -y upx-ucl
# Install Docker binary
RUN wget -nv https://get.docker.com/builds/Linux/x86_64/docker-1.3.3 -O /usr/bin/docker && \
  chmod +x /usr/bin/docker
RUN go get github.com/pwaller/goupx
RUN go get github.com/tools/godep
RUN go get bitbucket.org/nildev/tools/cmd/nildev
RUN go get -d bitbucket.org/nildev/lib

VOLUME /src/service /src/container
WORKDIR /src

COPY env.sh /
COPY build.sh /

ENTRYPOINT ["/build.sh"]