# aplty test

DEVELOPMENT FINISHED AND THEREFORE ARCHIVED.
THE WORKING SOLUTION CAN BE FOUND IN:

- https://github.com/osism/helm-charts
- https://github.com/osism/container-images

```sh
ssh ubuntu@213.131.230.228
# DO NOT USE GPG2!!!!!!!!!!!!!!!!!!!!!!
# GPG2 is not supported by aptly and GPG1 is NOT replaced by GPG2
apt install -y gnupg1 gpgv1 bzip2
wget -qO /root/aptly_1.5.0._amd64.deb https://github.com/aptly-dev/aptly/releases/download/v1.5.0/aptly_1.5.0_amd64.deb
dpkg -i /root/aptly_1.5.0._amd64.deb
rm /root/aptly_1.5.0._amd64.deb
gpg1 --gen-key
gpg1 --export --armor --output /opt/aptly/public/gpgkey OSISM
```

## affected repositories

Hosting mirror services: <https://github.com/osism/public-services>
Providing Helm charts: <https://github.com/osism/helm-charts>
Here should the yaml version files be stored: <https://github.com/osism/sbom>
Here should the yaml mirror files be stored: <https://github.com/osism/sbom>
Here should the scripts be stored that generate the yaml files: <https://github.com/osism/scripts>

## deb mirror config

aptly config show > /etc/aptly.conf

```shell
#!/bin/bash
# /opt/keys_gen.sh "foobar" "foo@bar.com" "123"
# gpg --no-default-keyring --keyring /usr/share/keyrings/debian-archive-keyring.gpg --export | gpg --no-default-keyring --keyring trustedkeys.gpg --import

mirror=testing
new_snapshot=new_snapshot
old_snapshot=current_snapshot
distribution=jammy
packages="nginx | apache2"

# initial setup
gpg --no-default-keyring --keyring /usr/share/keyrings/ubuntu-archive-keyring.gpg --export | gpg --no-default-keyring --keyring trustedkeys.gpg --import
aptly mirror create -filter="$packages" $mirror http://de.archive.ubuntu.com/ubuntu/ $distribution main
aptly mirror update $mirror
aptly snapshot create $old_snapshot from mirror $mirror
aptly publish snapshot -distribution=$distribution $old_snapshot $mirror

# updating and removing old snapshots
aptly mirror update $mirror
aptly snapshot create $new_snapshot from mirror $mirror
aptly publish switch $distribution $mirror $new_snapshot
aptly snapshot drop $old_snapshot
aptly snapshot rename $new_snapshot $old_snapshot
```

### deb client config

Use the following to fetch deb packages from your mirror-host by configuring `/etc/apt/sources.list` or similar:

```list
deb [trusted=yes arch=amd64,arm64 arch-=i386,armel,armhf] https://mirror.services.osism.tech/deb/ default  all
```

## helm-chart

```sh
helm repo add ingress-nginx https://helm.nginx.com/stable   
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
helm install aptly ./aptly-chart
```

## TODO

Test-Case mit nur einem oder mit zwei Spiegeln bauen und warten, bis alles gemirrored ist.
