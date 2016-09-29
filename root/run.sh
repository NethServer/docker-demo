#!/bin/bash

chown -c srvmgr:srvmgr /var/cache/nethserver-httpd-admin /var/log/httpd-admin

exec httpd -DFOREGROUND -f /etc/httpd/admin-conf/httpd.conf
