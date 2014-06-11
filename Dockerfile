# NethServer Community demo
#
# Version 0.1

FROM centos

MAINTAINER Giacomo Sanchietti, giacomo@nethesis.it

EXPOSE 980

RUN yum --disablerepo=* localinstall -y http://pulp.nethserver.org/nethserver/nethserver-release.rpm
RUN rpm --import /etc/pki/rpm-gpg/*

# Uncomment for local builds
#RUN sed -i 's/pulp.nethserver.org/birro.nethesis.it:8083/' /etc/yum.repos.d/NethServer.repo

RUN yum --disablerepo=* --enablerepo=nethserver-base,nethserver-updates,centos-base,centos-updates --exclude=kernel* --releasever=6.5 install rsyslog @nethserver-iso -y

#RUN service rsyslog start
RUN /etc/e-smith/events/actions/initialize-default-databases
RUN /etc/e-smith/events/actions/init-repo
RUN /sbin/e-smith/signal-event system-init; /sbin/e-smith/expand-template /etc/httpd/admin-conf/httpd.conf

RUN yum clean all
RUN yum --noplugins install --enablerepo=updates --exclude=nethserver-devbox nethserver-* -y || exit 0
RUN /etc/e-smith/events/actions/initialize-default-databases

# Remove unwanted RPMS

RUN rpm -e samba-winbind-clients samba-winbind samba samba-client samba-common sogo-tool sogo sope49-core sope49-gdl1 sope49-gdl1-mysql sope49-cards sope49-gdl1 sope49-ldap sope49-mime sope49-xml sope49-sbjson sope49-appserver gnustep-base gnustep-make dovecot clamav-db clamav squidclamav clamd squid amavisd-new spamassassin  squidGuard cifs-utils sope49-gdl1-contentstore dovecot-pigeonhole dovecot-antispam shorewall shorewall-core lsm lightsquid openvpn nut hylafax mysql-libs mysql-server mysql postfix php-mysql  perl-DBD-MySQL lightsquid-apache php-pear-MDB2-Driver-mysqli roundcubemail owncloud c-icap collectd  redis avahi dnsmasq openswan GConf2 libgsf nfs-utils-lib ntopng  nethserver-sogo-thunderbird --nodeps --noscripts 2>/dev/null || exit 0

RUN rpm -e fontconfig xorg-x11-font-utils libfontenc dejavu-sans-mono-fonts libXfont fontpackages-filesystem urw-fonts dejavu-fonts-common ghostscript-fonts  wxGTK librsvg2 ImageMagick perl-GD gd ghostscript cairo libXft rrdtool ghostscript gtk2 wxGTK-gl erlang-wx erlang-et erlang-debugger erlang-dialyzer erlang-reltool ejabberd erlang-common_test erlang-megaco erlang-observer erlang  erlang-webtool erlang-typer erlang-test_server rrdtool-perl collectd-rrdtool-  perl-GDGraph3d perl-GDGraph perl-GDTextUtil tk erlang-examples erlang-tools dejavu-lgc-sans-mono-fonts perl-RRD-Simple erlang-gs erlang-pman erlang-tv erlang-toolbar erlang-appmon pango poppler-utils poppler libgcj gettext-devel intltool nethserver-devbox --nodeps  --noscripts 2>/dev/null || exit 0

RUN rpm -e erlang-stdlib erlang-hipe erlang-mnesia erlang-public_key erlang-cosEvent erlang-edoc erlang-percept erlang-sasl erlang-inviso erlang-os_mon erlang-ic erlang-jinterface erlang-kernel erlang-runtime_tools erlang-ssl erlang-cosTime erlang-ssh- erlang-asn1 erlang-docbuilder erlang-eunit erlang-erl_docgen erlang-crypto erlang-syntax_tools erlang-snmp erlang-inets erlang-cosNotification erlang-cosFileTransfer erlang-odbc erlang-diameter erlang-esasl erlang-erts erlang-compiler erlang-xmerl erlang-orber erlang-cosProperty erlang-otp_mibs erlang-cosEventDomain- erlang-cosTransactions erlang-parsetools erlang-erl_interface --nodeps  --noscripts 2>/dev/null || exit 0

RUN rpm -e wireless-tools unixODBC sane-backends sane-backends-libs sane-backends-libs-gphoto2 ppp owncloud-3rdparty  ntp mesa-dri-drivers mesa-dri-filesystem mesa-dri1-drivers mesa-libGL mesa-libGLU mesa-private-llvm hplip-libs xl2tpd GeoIP hpijs SDL ORBit2 autoconf automake c-icap-libs cabextract cups-libs  hplip-common iaxmodem python-imaging python-docutils nut-client cups --nodeps  --noscripts 2>/dev/null || exit 0

# Clean up unused files

RUN rm -rf /var/lib/mysql/ /var/lib/clamav/ /var/tmp/* /tmp/* /var/cache/yum

# Fake commands

ADD gui/PamAuthenticator.php /usr/share/nethesis/Nethgui/Utility/PamAuthenticator.php
ADD gui/module/Printers.php /usr/share/nethesis/NethServer/Module/Dashboard/Printers.php
ADD gui/template/Printers.php /usr/share/nethesis/NethServer/Template/Dashabord/Printers.php
ADD scripts/raid-status /usr/libexec/nethserver/raid-status
ADD scripts/mail-quota /usr/libexec/nethserver/mail-quota
ADD scripts/read-dhcp-leases /usr/libexec/nethserver/read-dhcp-leases
ADD scripts/read-service-status /usr/libexec/nethserver/read-service-status
ADD scripts/upsc /usr/bin/upsc
ADD scripts/providers-status /usr/bin/providers-status
ADD scripts/signal-event /sbin/e-smith/signal-event
ADD scripts/sudo /usr/bin/sudo
ADD scripts/start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh

# Start web interface

ENTRYPOINT ["/usr/local/bin/start.sh"]

