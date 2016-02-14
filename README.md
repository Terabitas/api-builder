# Building

To build container:

```
docker build -t nildev/api-builder:latest .
docker build -t quay.io/nildev/base_builder:latest .
```

# How to use

Get `nildev` tool:
```
go get github.com/nildev/tools/cmd/nildev
```

Build container:
```
nildev build github.com/nildev/account
```