#
# NethServer Docker demo
#

FROM centos:latest

EXPOSE 980

ADD root/ /srv/root
RUN useradd -G adm -r srvmgr && \
    chown -c -R root:root /srv/root && \
    /srv/root/build-docker-demo && \
    rsync -aiI /srv/root/ /

ENTRYPOINT ["/run.sh"]

