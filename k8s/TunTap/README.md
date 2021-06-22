# Virtual Network Interface creation between mac and docker

## Install TunTap Shim
[TunTap](http://tuntaposx.sourceforge.net/) provides kernel extentions for macOS that allow it to create virtual network interfaces. 

> You can find the message `No longer maintained` but it is still useful for Mac OS 11

```shell
$ brew install tuntap
```

## Download docker-tuntap-osx
After installation, you need to download the shell script for virtual network interface installation script - [docker-tuntap-osx](https://github.com/AlmirKadric-Published/docker-tuntap-osx)

```shell
$ git clone https://github.com/AlmirKadric-Published/docker-tuntap-osx.git && cd docker-tuntap-osx && ls -l sbin

Cloning into 'docker-tuntap-osx'...
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 96 (delta 0), reused 1 (delta 0), pack-reused 91
Unpacking objects: 100% (96/96), 22.65 KiB | 483.00 KiB/s, done.
total 32
-rwxr-xr-x  1 jos  staff  1306 Dec  6 13:11 docker.hyperkit.tuntap.sh
-rwxr-xr-x  1 jos  staff  2116 Dec  6 13:11 docker_tap_install.sh
-rwxr-xr-x  1 jos  staff  1109 Dec  6 13:11 docker_tap_uninstall.sh
-rwxr-xr-x  1 jos  staff   455 Dec  6 13:11 docker_tap_up.sh
```

## Install docker-tuntap-osx

Run ./sbin/docker_tap_install.sh to install the shim.

```shell
docker-tuntap-osx $ ./sbin/docker_tap_install.sh

Installation complete
Restarting Docker
Process restarting, ready to go
```

After Docker restarts run ifconfig | grep tap. You should see output like:

```shell
tap1: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
```

If a tap1 network interface appears you can now bring it up.

```shell
docker-tuntap-osx $ ./sbin/sbin/docker_tap_up.sh
```

Enter your password then run ifconfig | grep -A 5 tap.

You should see output like:

```shell
tap1: flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST> mtu 1500
        ether 9a:3e:ca:ad:4b:93 
        inet 10.0.75.1 netmask 0xfffffffc broadcast 10.0.75.3
        media: autoselect
        status: active
        open (pid 15370)
```

Verify the network interface has a status of active.

Next update your routing tables based on your Docker config. To do that first get the Subnet “CIDR block” value from the cluster’s docker network:

```shell
$ docker network inspect kind | jq '.[0].IPAM.Config[0]'
{
  "Subnet": "172.19.0.0/16",
  "Gateway": "172.19.0.1"
}
```

Then add a new route to the routing table:

```shell
$ sudo route -v add -net 172.19.0.1 -netmask 255.255.0.0 10.0.75.2

u: inet 172.19.0.1; u: inet 10.0.75.2; u: inet 255.255.0.0; RTM_ADD: Add Route: len 132, pid: 0, seq 1, errno 0, flags:<UP,GATEWAY,STATIC>
locks:  inits:
sockaddrs: <DST,GATEWAY,NETMASK>
 172.19.0.1 10.0.75.2 255.255.0.0
add net 172.19.0.1: gateway 10.0.75.2
```

> If you don't know the subnet mask, use the [online calculator](https://networkcalc.com/subnet-calculator/172.19.0.0/16).


