#!/bin/bash

/usr/libexec/nethserver/smwingsd
httpd-admin -D FOREGROUND -f /etc/httpd/admin-conf/httpd.conf

