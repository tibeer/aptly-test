#!/bin/bash
#gpg1 --gen-key
distribution=jammy

aptly mirror create m000001 http://de.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse
aptly mirror create m000002 http://de.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse
aptly mirror create m000003 http://de.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse
aptly mirror create m000004 http://de.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse
aptly mirror create m000005 http://de.archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
aptly mirror create m000006 http://de.archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
aptly mirror create m000007 http://de.archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
aptly mirror create m000008 http://de.archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
aptly mirror create m000009 http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /
aptly mirror create m000010 http://download.opensuse.org/repositories/home:/katacontainers:/releases:/x86_64:/stable-1.11/xUbuntu_18.04/ /
aptly mirror create m000011 http://downloads.mariadb.com/MariaDB/mariadb-10.3/repo/ubuntu focal main
aptly mirror create m000012 http://packages.treasuredata.com/4/ubuntu/focal/ focal contrib
aptly mirror create m000013 http://ports.ubuntu.com/ubuntu-ports/ bionic main restricted universe multiverse
aptly mirror create m000014 http://ports.ubuntu.com/ubuntu-ports/ bionic-backports main restricted universe multiverse
aptly mirror create m000015 http://ports.ubuntu.com/ubuntu-ports/ bionic-security main restricted universe multiverse
aptly mirror create m000016 http://ports.ubuntu.com/ubuntu-ports/ bionic-updates main restricted universe multiverse
aptly mirror create m000017 http://ports.ubuntu.com/ubuntu-ports/ focal main restricted universe multiverse
aptly mirror create m000018 http://ports.ubuntu.com/ubuntu-ports/ focal-backports main restricted universe multiverse
aptly mirror create m000019 http://ports.ubuntu.com/ubuntu-ports/ focal-security main restricted universe multiverse
aptly mirror create m000020 http://ports.ubuntu.com/ubuntu-ports/ focal-updates main restricted universe multiverse
aptly mirror create m000021 http://ppa.launchpad.net/qpid/released/ubuntu/ focal main
aptly mirror create m000022 http://ppa.launchpad.net/rabbitmq/rabbitmq-erlang/ubuntu focal main
aptly mirror create m000023 http://repository.betacloud.xyz:8080/node-2020-01-31 bionic main
aptly mirror create m000024 http://ubuntu-cloud.archive.canonical.com/ubuntu focal-updates/victoria main
aptly mirror create m000025 http://ubuntu-cloud.archive.canonical.com/ubuntu focal-updates/wallaby main
aptly mirror create m000026 http://ubuntu-cloud.archive.canonical.com/ubuntu focal-updates/xena main
aptly mirror create m000027 http://ubuntu-cloud.archive.canonical.com/ubuntu focal-updates/yoga main
aptly mirror create m000028 https://apt.kubernetes.io/ kubernetes-xenial main
aptly mirror create m000029 https://apt.releases.hashicorp.com focal main
aptly mirror create m000030 https://aquasecurity.github.io/trivy-repo/deb focal main
aptly mirror create m000031 https://artifacts.elastic.co/packages/6.x/apt stable main
aptly mirror create m000032 https://artifacts.elastic.co/packages/oss-6.x/apt stable main
aptly mirror create m000033 https://artifacts.elastic.co/packages/oss-7.x/apt stable main
aptly mirror create m000034 https://dl.bintray.com/falcosecurity/deb stable main
aptly mirror create m000035 https://dl.bintray.com/rabbitmq-erlang/debian/ focal erlang
aptly mirror create m000036 https://dl.bintray.com/rabbitmq/debian bionic main
aptly mirror create m000037 https://download.ceph.com/debian-octopus focal main
aptly mirror create m000038 https://download.ceph.com/debian-octopus/ focal main
aptly mirror create m000039 https://download.ceph.com/debian-pacific focal main
aptly mirror create m000040 https://download.ceph.com/debian-quincy focal main
aptly mirror create m000041 https://download.docker.com/linux/ubuntu bionic stable
aptly mirror create m000042 https://download.docker.com/linux/ubuntu focal stable
aptly mirror create m000043 https://download.docker.com/linux/ubuntu xenial stable
aptly mirror create m000044 https://download.sysdig.com/stable/deb stable-amd64
aptly mirror create m000045 https://download.sysdig.com/stable/deb stable-amd64/
aptly mirror create m000046 https://packagecloud.io/netdata/netdata-edge/ubuntu/ focal main
aptly mirror create m000047 https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ focal main
aptly mirror create m000048 https://packages.cisofy.com/community/lynis/deb/ stable main
aptly mirror create m000049 https://packages.grafana.com/oss/deb stable main
aptly mirror create m000050 https://repos.influxdata.com/ubuntu focal stable

mirrors=$(aptly mirror list -raw)

# aptly mirror update m000001
# aptly mirror update m000002
# aptly mirror update m000003
for mirror in ${mirrors}; do
  aptly mirror update "${mirror}"
done

#aptly snapshot create s000001 from mirror m000001
#aptly snapshot create s000002 from mirror m000002
#aptly snapshot create s000003 from mirror m000003
for mirror in ${mirrors}; do
  aptly snapshot create "${mirror//m/s}" from mirror "${mirror}"
done

# create a concated list of names
for mirror in ${mirrors}; do
  snapshots="${snapshots} ${mirror//m/s}"
done
# shellcheck disable=SC2086
aptly snapshot merge osism-mirror ${snapshots}
unset snapshots
aptly publish snapshot -distribution="${distribution}" -passphrase="SOMERANDOMPASSWORD" osism-mirror osism-mirror
