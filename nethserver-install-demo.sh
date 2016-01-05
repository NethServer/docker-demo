#!/bin/bash

#
# Copyright (C) 2015 Nethesis S.r.l.
# http://www.nethesis.it - nethserver@nethesis.it
#
# This script is part of NethServer.
#
# NethServer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License,
# or any later version.
#
# NethServer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with NethServer.  If not, see COPYING.
#

set -e

yum -y install yum-utils
yum -y --disablerepo=* localinstall http://mirror.nethserver.org/nethserver/nethserver-release-6.7.rpm

nethserver-install

packages=/tmp/packages
for group in  nethserver-backup \
    nethserver-bandwidth-monitor \
    nethserver-dns-dhcp \
    nethserver-fax-server \
    nethserver-faxweb2 \
    nethserver-file-server \
    nethserver-firewall-base \
    nethserver-ftp \
    nethserver-groupware \
    nethserver-ips \
    nethserver-mail \
    nethserver-messaging \
    nethserver-mysql \
    nethserver-net-snmp \
    nethserver-nut \
    nethserver-owncloud \
    nethserver-p3scan \
    nethserver-pop3connector \
    nethserver-printers \
    nethserver-smtp-proxy \
    nethserver-statistics \
    nethserver-vpn \
    nethserver-web \
    nethserver-web-filter \
    nethserver-web-proxy \
    nethserver-webvirtmgr; do
   yum groupinfo ${group} |  sed -n '/^   nethserver/ p' >> ${packages}
done

echo 'nethserver-lang-*' >> ${packages}
echo 'passwd' >> ${packages}

downloaddir=/tmp/rpms
mkdir -p ${downloaddir}
yumdownloader --destdir=${downloaddir} $(sort < ${packages} | uniq)
rpm -i --nodeps --replacepkgs ${downloaddir}/*.rpm
rm -rf ${downloaddir} ${packages}
yum --enablerepo=* clean all



