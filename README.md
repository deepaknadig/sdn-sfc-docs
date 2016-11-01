Service Function Chaining with ONOS and Openstack Guide
========================================================

This is a work in progress.

1. Pre-requisites
-----------------------


```shell
sudo apt-get update
sudo apt-get -y install git
```

Enable no sudo password for user ubuntu
```shell
sudo visudo
```

Now enter `ubuntu ALL=(ALL) NOPASSWD:ALL` at the end of the file.

Reboot.

1a. Install OVS with NSH Support
----------------------------------

Use the `install_ovs.sh` script OR the `install_ovs_nsh.sh` script (latter preferred?)



2. ONOS Installation
-----------------------
```shell
sudo apt-get update

cd; mkdir Downloads Applications
cd Downloads
wget -nc http://archive.apache.org/dist/karaf/3.0.5/apache-karaf-3.0.5.tar.gz
tar -zxvf apache-karaf-3.0.5.tar.gz -C ../Applications/

sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer oracle-java8-set-default -y

sudo apt-get purge maven maven2 maven3
sudo apt-add-repository ppa:andrei-pozolotin/maven3
sudo apt-get update
sudo apt-get install maven3
```

Logout and log back in so that the environment variables like `JAVA_HOME, MAVEN` etc. are set 


```shell
cd; git clone https://gerrit.onosproject.org/onos
cd onos
git checkout origin/onos-1.7
git pull origin onos-1.7
```

Edit `~/.bashrc` and add the ONOS environment variables

```shell
# ONOS Environment Variables
export ONOS_ROOT=~/onos
source $ONOS_ROOT/tools/dev/bash_profile
# Set ONOS_IP to reflect the right interface IP address 
ONOS_IP="$(ifconfig eth0 | grep "inet addr" | awk -F'[: ]+' '{print $4 }')"
```
Edit `onos/tools/test/cells/local` and remove `proxyarp` if you have ARP problems with a hardware switch.

Pull the new environment variables

`source .bashrc` 


Build and Install ONOS with

```shell
mvn clean install
op
```

Create a tmux session and start onos with the command below, and also in a new tab enable logging with `tl`

```shell
ok clean

```

3. Devstack Installation
---------------------------


```shell
cd; 
git clone https://git.openstack.org/openstack-dev/devstack -b stable/newton
cd devstack
```
Create a `local.conf` file and add the following:

```shell
[[local|localrc]]
DEST=/opt/stack 
#OFFLINE=True 

# Logging 
LOGFILE=$DEST/logs/stack.sh.log 
VERBOSE=True 
LOG_COLOR=False 
SCREEN_LOGDIR=$DEST/logs/screen 

# Credentials 
ADMIN_PASSWORD=openstack 
MYSQL_PASSWORD=openstack 
RABBIT_PASSWORD=openstack 
SERVICE_PASSWORD=openstack 
SERVICE_TOKEN=tokentoken 

# Neutron - Networking Service 
#DISABLED_SERVICES=n-net 
ENABLED_SERVICES+=,q-svc,q-agt,q-dhcp,q-l3,q-meta,neutron
enable_plugin networking-sfc https://github.com/openstack/networking-sfc 

```

Build Devstack

```shell
sudo rm -rvf /opt/stack
./unstack.sh
./clean.sh
./stack.sh
```

Enable `networking-sfc` and `networking-onos` plugins

Update networking-sfc's setup.cfg with onos driver information:

```shell
networking_sfc.sfc.drivers =
    onos = networking_onos.services.sfc.driver:OnosSfcDriver
```

Update [[local|localrc]] with:

```shell
enable_plugin networking-sfc git://git.openstack.org/openstack/networking-sfc
enable_plugin networking-onos git://git.openstack.org/openstack/networking-onos

Unstack and Stack again


```
Problem with liberasurecode?
sudo apt-get install liberasurecode-dev


Configuration Changes
--------------------------

Copy the `conf_onos.ini` from `/opt/stack/networking-onos/etc/` to `/etc/neutron/plugins/ml2/`

`sudo cp /opt/stack/networking-onos/etc/conf_onos.ini /etc/neutron/plugins/ml2/`

Edit the file to update the correct ONOS URL, username and password.



TODO
-----
5. Service Function Chaining
6. Testing
8. Teardown
