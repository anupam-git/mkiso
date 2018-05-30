#! /bin/sh

export LANG=C
export LC_ALL=C

METAPACKAGE_PACKAGES='
dpkg
net-tools
resolvconf
'

PACKAGES='
nxos-desktop
lupin-casper
casper
linux-image-generic
calamares
calamares-settings-nxos
'

PACKAGES=$(echo $PACKAGES | tr '\n' ' ')
METAPACKAGE_PACKAGES=$(echo $METAPACKAGE_PACKAGES | tr '\n' ' ')

apt-get update
apt-get install -y apt-transport-https wget ca-certificates gnupg2 apt-utils

wget -q http://repo.nxos.org/public.key -O nxos.key
if echo b51f77c43f28b48b14a4e06479c01afba4e54c37dc6eb6ae7f51c5751929fccc nxos.key | sha256sum -c; then
	apt-key add nxos.key
	echo 'deb http://repo.nxos.org/testing/ nxos main' >> /etc/apt/sources.list
fi
rm nxos.key

apt-get update
apt-get dist-upgrade -y
apt-get install -y $PACKAGES $METAPACKAGE_PACKAGES || exit 1
apt-get clean
useradd -m -U -G sudo,cdrom,adm,dip,plugdev -p '' me
echo 'me:nitrux' | chpasswd
echo host > /etc/hostname
find /var/log -regex '.*?[0-9].*?' -exec rm -v {} \;
rm /etc/resolv.conf
