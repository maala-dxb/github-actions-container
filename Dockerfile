FROM amd64/ubuntu:23.04


MAINTAINER Maala Mhrez "maala.m.mhrez@gmail.com"

USER root

ARG ssh_prv_key
ARG ssh_pub_key

RUN apt-get update && \
    apt-get -y install curl && \
    apt-get -y install sudo && \
    apt-get -y install git && \
    apt-get -y install docker && \
    apt-get -y install docker.io && \
    apt-get -y install systemctl

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh
# See: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
#COPY known_hosts /root/.ssh/known_hosts


# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

RUN  echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

# See: https://linuxhandbook.com/known-hosts-file/
# add github as legitimate server
RUN touch /root/.ssh/known_hosts
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
RUN ssh-keyscan -H github.com >> ~/.ssh/known_hosts

RUN git clone git@github.com:maala-dxb/dev-env.git && \
    cd dev-env && \
    bash setup.sh

RUN git clone git@github.com:maala-dxb/python-backend-boilerplate.git
RUN usermod -aG docker root

COPY . /

RUN chmod +x /run.sh


CMD ["/run.sh"]