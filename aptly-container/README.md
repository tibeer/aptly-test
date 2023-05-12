# building the image

```sh
podman build --arch=amd64 -t aptly -f Containerfile
```

## rebuilding

```sh
podman rm -f aptly && podman build --arch=amd64 -t aptly -f Containerfile && podman run -d --name aptly aptly && podman exec -it aptly bash
```
