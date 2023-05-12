#!/bin/bash
distribution=jammy
mirrors=$(aptly mirror list -raw)

# aptly mirror update m000001
# aptly mirror update m000002
# aptly mirror update m000003
for mirror in ${mirrors}; do
  aptly mirror update "${mirror}"
done

#aptly snapshot create n000001 from mirror m000001
#aptly snapshot create n000002 from mirror m000002
#aptly snapshot create n000003 from mirror m000003
for mirror in ${mirrors}; do
  snapshot="${mirror//m/n}"
  aptly snapshot create "${snapshot}" from mirror "${mirror}"
done

#aptly publish switch "${distribution}" m000001 n000001
#aptly publish switch "${distribution}" m000002 n000002
#aptly publish switch "${distribution}" m000003 n000003
for mirror in ${mirrors}; do
  snapshot="${mirror//m/n}"
  aptly publish switch  "${distribution}" "${mirror}" "${snapshot}"
done

#aptly snapshot drop s000001
#aptly snapshot drop s000002
#aptly snapshot drop s000003
for mirror in ${mirrors}; do
  snapshot="${mirror//m/s}"
  aptly snapshot drop "${snapshot}"
done

#aptly snapshot rename n000001 s000001
#aptly snapshot rename n000002 s000002
#aptly snapshot rename n000003 s000003
for mirror in ${mirrors}; do
  snapshot_new="${mirror//m/n}"
  snapshot_old="${mirror//m/s}"
  aptly snapshot rename "${snapshot_new}" "${snapshot_old}"
done

# create a concated list of names
for mirror in ${mirrors}; do
  snapshots="${snapshots} ${mirror//m/s}"
done
# shellcheck disable=SC2086
aptly snapshot merge osism-mirror-new ${snapshots}
aptly snapshot drop osism-mirror
aptly snapshot rename osism-mirror-new osism-mirror
aptly publish update "${distribution}" -passphrase="SOMERANDOMPASSWORD" osism-mirror
