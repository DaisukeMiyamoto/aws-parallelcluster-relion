#!/bin/bash -xeu

sudo apt install -y cmake git build-essential libfftw3-dev libtiff-dev

#################################################################
#
# Intel oneAPI
#
# Based on this site:
# https://software.intel.com/content/www/us/en/develop/documentation/installation-guide-for-intel-oneapi-toolkits-linux/top/installation/install-using-package-managers/apt.html

# use wget to fetch the Intel repository public key
cd /tmp
wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
# add to your apt sources keyring so that archives signed with this key will be trusted.
sudo apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
# remove the public key
rm GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
echo "deb https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list

sudo add-apt-repository "deb https://apt.repos.intel.com/oneapi all main"
sudo apt install -y intel-basekit intel-hpckit

#source /opt/intel/oneapi/setvars.sh
