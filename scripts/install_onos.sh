#!/bin/bash

# TODO Update Maven to v3 for 14.04
# Use script only with Ubuntu Xenial

cd; mkdir Downloads Applications
cd Downloads
wget -nc http://archive.apache.org/dist/karaf/3.0.5/apache-karaf-3.0.5.tar.gz
tar -zxvf apache-karaf-3.0.5.tar.gz -C ../Applications/
cd
sudo apt-get install software-properties-common -y

sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo apt-get install oracle-java8-installer oracle-java8-set-default -y
sudo apt-get install maven -y

cd; git clone https://gerrit.onosproject.org/onos -b onos-1.7

mvn clean install







