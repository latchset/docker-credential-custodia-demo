FROM fedora:24
MAINTAINER Christian Heimes <cheimes@redhat.com>

RUN dnf -y update && dnf clean all
# install Custodia dependencies
RUN dnf -y install \
        python3 python3-pip \
        python3-requests python3-docker-py \
        python3-six python3-jwcrypto \
    && dnf clean all

# misc directories
RUN mkdir -p -m755 \
    /etc/custodia \
    /var/log/custodia \
    /var/run/custodia \
    /var/lib/custodia \
    /usr/local/custodia \
    /root/.docker

# install docker to get Docker >1.11
ADD docker.repo /etc/yum.repos.d/docker.repo
RUN dnf -y install docker-engine && dnf clean all

## install sssd
#RUN dnf -y install sssd-common procps-ng && dnf clean all
#ADD sssd.conf /etc/sssd/sssd.conf
#RUN chmod 600 /etc/sssd/sssd.conf && chown root:root /etc/sssd/sssd.conf

# install custodia
ADD custodia/ /usr/local/custodia/
RUN cd /usr/local/custodia/ && pip3 install .

# go cli
ADD godeps/src/github.com/latchset/docker-credential-custodia/docker-credential-* \
    /usr/bin/

# config
ADD docker_config.json /root/.docker/config.json
ADD custodia.conf /etc/custodia/custodia.conf

# run.sh
ADD run.sh /run.sh

CMD ["/run.sh"]
