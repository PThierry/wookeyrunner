# H2lab wookey SDK runner system
#
# VERSION               0.1
# DOCKER-VERSION        0.2

from	debian:buster

# make sure the package repository is up to date
run echo "deb http://deb.debian.org/debian/ buster contrib non-free" >> /etc/apt/sources.list
run	apt-get update

# debian packages dependencies
run	apt install -yq bash repo sudo git make python-pip python3-pip python-pyscard python-crypto openjdk-11-jdk maven ant curl zip unzip bash kconfig-frontends bzip2 vim emacs-nox python-sphinx imagemagick python-docutils texlive-pictures texlive-latex-extra texlive-fonts-recommended latexmk ghostscript coreutils fdisk wget gcc-arm-none-eabi

# python dependencies (out of debian)
run pip install intelhex

# installing Ada toolchain
run wget -O /tmp/gnat-community-2018-20180524-arm-elf-linux64-bin https://community.download.adacore.com/v1/6696259f92b40178ab1cc1d3e005acf705dc4162?filename=gnat-community-2019-20190517-arm-elf-linux64-bin
run echo "6696259f92b40178ab1cc1d3e005acf705dc4162  /tmp/gnat-community-2018-20180524-arm-elf-linux64-bin" > /tmp/gnat.sha1sum
run sha1sum -c /tmp/gnat.sha1sum

run chmod +x /tmp/gnat-community-2018-20180524-arm-elf-linux64-bin

run git clone https://github.com/AdaCore/gnat_community_install_script.git /tmp/gnat_install
run /tmp/gnat_install/install_package.sh /tmp/gnat-community-2018-20180524-arm-elf-linux64-bin /opt/adacore-arm-eabi

# installing Javacard SDK
run git clone https://github.com/martinpaljak/oracle_javacard_sdks.git /tmp/oracle_sdks

run groupadd build
run useradd -d /build -ms /bin/bash -g build build;
run usermod -a -G sudo build;

# this is required to allow openocd, dfu-util and pcsc usage when interacting with the device and Javacards from Docker (see README)
run /bin/dash -c 'echo "build    ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/build; \
                  chmod 0440 /etc/sudoers.d/build'

user build:build
workdir /build

# adding cross gcc and Gnat toolchains to the user PATH variable
run echo "export PATH=/opt/adacore-arm-eabi/bin:/usr/local/bin:$PATH" > /build/.bashrc;

# overrideable
cmd ["/bin/bash"]
