# building the image

```sh
podman build --arch=amd64 -t aptly-nginx -f Containerfile
```

## rebuilding

```sh
podman rm -f aptly-nginx && podman build --arch=amd64 -t aptly-nginx -f Containerfile && podman run -d -p 8080:80 --name aptly-nginx aptly-nginx && podman exec -it aptly-nginx bash
```
