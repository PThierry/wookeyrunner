# H2lab wookey SDK runner system
#
# VERSION               0.1
# DOCKER-VERSION        0.2

from	debian:sid

# make sure the package repository is up to date
run echo "deb http://deb.debian.org/debian/ sid contrib non-free" >> /etc/apt/sources.list
run apt-get update

# debian packages dependencies
run apt-get install -yq bash repo sudo git make python3-pip python3-pyscard python3-crypto openjdk-11-jdk maven ant curl zip unzip kconfig-frontends bzip2 python3-sphinx coreutils fdisk wget gcc-arm-none-eabi python3-coverage

# python dependencies (out of debian)
run pip3 install intelhex

# installing Ada toolchain
run wget -O /tmp/gnat-community-2018-20180524-arm-elf-linux64-bin https://community.download.adacore.com/v1/6696259f92b40178ab1cc1d3e005acf705dc4162?filename=gnat-community-2019-20190517-arm-elf-linux64-bin
run echo "6696259f92b40178ab1cc1d3e005acf705dc4162  /tmp/gnat-community-2018-20180524-arm-elf-linux64-bin" > /tmp/gnat.sha1sum
run sha1sum -c /tmp/gnat.sha1sum

run chmod +x /tmp/gnat-community-2018-20180524-arm-elf-linux64-bin

# installing Javacard SDK
run git clone https://github.com/martinpaljak/oracle_javacard_sdks.git /opt/oracle_sdks
# and clean git
run rm -rf /opt/oracle_sdks/.git

run git clone https://github.com/AdaCore/gnat_community_install_script.git /tmp/gnat_install
run /tmp/gnat_install/install_package.sh /tmp/gnat-community-2018-20180524-arm-elf-linux64-bin /opt/adacore-arm-eabi
# lcleaning
run rm -rf /tmp/gnat*


# adding cross gcc and Gnat toolchains to the user PATH variable, system wide
run echo "export PATH=/opt/adacore-arm-eabi/bin:/usr/local/bin:$PATH" >> /etc/bash.bashrc;
# set default python to python3 in SID (while Debian has not fixed python usage)
run echo "export PYTHON_CMD=python3" >> /etc/bash.bashrc;

# overrideable
cmd ["/bin/bash"]
