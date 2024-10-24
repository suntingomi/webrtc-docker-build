#!/bin/bash

set -ex

apt-get update
apt-get -y upgrade

apt-get -y install tzdata
echo 'Asia/Shanghai' > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

export DEBIAN_FRONTEND=noninteractive

apt-get -y install \
  binutils \
  git \
  locales \
  lsb-release \
  pkg-config \
  python3 \
  ninja-build \
  python3-setuptools \
  rsync \
  sudo \
  unzip \
  vim \
  wget \
  xz-utils
