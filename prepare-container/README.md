# building the image

```sh
podman build --arch=amd64 -t aptly-prepare -f Containerfile
```

## rebuilding

```sh
podman rm -f aptly-prepare && podman build --arch=amd64 -t aptly-prepare -f Containerfile && podman run -d --name aptly-prepare aptly-prepare && podman exec -it aptly-prepare bash
```
