#
# NethServer Docker demo
#

FROM centos:centos6

MAINTAINER NethServer, http://www.nethserver.org

EXPOSE 980

COPY nethserver-install-demo.sh  /usr/local/bin/
RUN nethserver-install-demo.sh

COPY nethserver-config-demo.sh /usr/local/bin/
RUN nethserver-config-demo.sh
ADD root/ /

# Start web interface
ENTRYPOINT ["/usr/sbin/httpd-admin", "-D", "FOREGROUND", "-f", "/etc/httpd/admin-conf/httpd.conf"]

