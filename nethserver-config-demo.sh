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
set -x

/etc/e-smith/events/actions/initialize-default-databases init || :

for L in en_GB en_US it_IT ru_RU es_ES el_GR; do
    if locale -a | grep -q "^$L"; then
       LANG=$L.utf8 /sbin/e-smith/pkginfo compsdump > /var/lib/pkginfo-compsdump-$L.json
    fi
done

# Set root password to default:
PASSWORD="Nethesis,1234"
echo -e "$PASSWORD\n$PASSWORD" | /usr/bin/passwd --stdin root

rm -f /etc/e-smith/events/password-modify/S25password-set
/sbin/e-smith/config setprop httpd-admin ForcedLoginModule ''

/sbin/e-smith/config set SystemName demo
/sbin/e-smith/config set DomainName nethserver.org
mkdir -p /var/log/snort

# Disable error reporting:
sed -i "/^ini_set('error_reporting'/ c \
ini_set('error_reporting', 0); \
" /usr/share/nethesis/nethserver-manager/index.php

yum --enablerepo=* clean all
