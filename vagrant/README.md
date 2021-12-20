# Vagrant for k8s (On going)

In this document, I will explain how to set up the Virtual machine for k8s in M1 Pro Macbook. 
As you already know, M1 chip is new one so that there are many restriction to use present tools. 
For example, Virtual box and Vmware is not fully supporting M1 chip at this moment.
(It might be supportable when you see this document. Then, it is lucky!!)

For this reason, I will use Docker provider for the vagrant and create the several VM for k8s. 

## Vagrant with Docker provider

Fortunately, Docker desktop is working well in M1 Pro macbook and Docker is one of the providers for Vagrant. 
So, I will use these options for my local test environment. 

To use the Vagrant with Docker provider, first we need the image which can run `arm64` architecture. 

### Build Linux image for arm64

#### Docker buildx
Docker Buildx is a CLI plugin that extends the docker command with the full support of the features provided by Moby BuildKit builder toolkit. 
It provides the same user experience as docker build with many new features like creating scoped builder instances and building against multiple nodes concurrently.
Docker Buildx is included in Docker Desktop so you can use this if you installed Docker desktop.

#### Dockefile 
[Dockcerfile.Debian](./Dockerfile.Debian)
```
FROM debian:buster
LABEL MAINTAINER="Allen Kim <corono1004@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get -y install openssh-server passwd sudo man-db curl wget vim-tiny \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    ln -s /lib/systemd/systemd /usr/sbin/init;

RUN useradd -m -G sudo -s /bin/bash vagrant && \
    echo "vagrant:vagrant" | chpasswd && \
    echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant && \
    chmod 440 /etc/sudoers.d/vagrant

RUN systemctl enable ssh.service
EXPOSE 22

RUN mkdir -p /home/vagrant/.ssh
RUN chmod 700 /home/vagrant/.ssh

ADD https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys

RUN chmod 600 /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
```

#### Build command
```bash
$ docker buildx build -f Dockerfile.debian --platform linux/arm64 --tag coolexplorer/vagrant-docker:ubuntu . --push
```

### Vagrantfile
[Vagrantfile](./Vagrantfile)
```
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

Vagrant.configure("2") do |config|
    config.vm.hostname = "k8s-node"

    config.vm.provider "docker" do |docker|
        docker.image = "coolexplorer/vagrant-docker:ubuntu"
        docker.remains_running = true
        docker.has_ssh = true
        docker.privileged = true
        docker.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:ro"]
    end
end
```

#### Vagrant command

Vagrant up
```bash
$ vagrant up --provider=docker
```

Vagrant destroy
```bash
$ vagrant destroy -f
```
