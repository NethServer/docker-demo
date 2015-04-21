#!/bin/bash

set -x

function shutdown() {
    [ -n "${WITH_SSH}" ] && service sshd stop
    kill -TERM $(ps -C smwingsd -o pid | grep -v PID)
    httpd-admin -f /etc/httpd/admin-conf/httpd.conf -k stop
}

trap shutdown HUP INT QUIT KILL TERM EXIT

[ -n "${WITH_SSH}" ] && service sshd start
/usr/libexec/nethserver/smwingsd
httpd-admin -D FOREGROUND -f /etc/httpd/admin-conf/httpd.conf -k start &>/dev/null &
wait
