#!/bin/bash
gpg1 --gen-key
gpg1 --export --armor --output /opt/aptly/public/gpgkey OSISM
distribution=jammy

# import gpg keys
for key in $(curl -sL https://raw.githubusercontent.com/osism/sbom/main/mirrors.yaml | yq '.["deb_mirrors"].[].gpg_url'); do
  curl -sL "${key}" | gpg1 --no-default-keyring --keyring trustedkeys.gpg --import
done

# create aptly mirrors
counter=0
mirrors=()
readarray -t -O "${#mirrors[@]}" mirrors < <( curl -sL https://raw.githubusercontent.com/osism/sbom/main/mirrors.yaml | yq '.["deb_mirrors"].[].mirror') 
for mirror in "${mirrors[@]}"; do
  counter=$((counter + 1))
  # shellcheck disable=SC2086
  aptly mirror create "$(printf 'm%06d' ${counter})" ${mirror}
done
unset counter
unset mirrors

# aptly mirror update m000001
# aptly mirror update m000002
# aptly mirror update m000003
for mirror in $(aptly mirror list -raw); do
  aptly mirror update "${mirror}"
done

#aptly snapshot create s000001 from mirror m000001
#aptly snapshot create s000002 from mirror m000002
#aptly snapshot create s000003 from mirror m000003
for mirror in $(aptly mirror list -raw); do
  aptly snapshot create "${mirror//m/s}" from mirror "${mirror}"
done

# create a concated list of names
for mirror in $(aptly mirror list -raw); do
  snapshots="${snapshots} ${mirror//m/s}"
done
# shellcheck disable=SC2086
aptly snapshot merge osism-mirror ${snapshots}
unset snapshots
aptly publish snapshot -distribution="${distribution}" -passphrase="SOMERANDOMPASSWORD" osism-mirror osism-mirror
