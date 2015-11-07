FROM fedora:23

MAINTAINER Ty Auvil https://github.com/tyauvil

ENV URL='https://plex.tv/downloads/latest/1?channel=8&build=linux-ubuntu-x86_64&distro=redhat'

RUN useradd --system --uid 797 -M --shell /usr/sbin/nologin plex && \
    rpm -ivh $(curl -w "%{url_effective}\n" -I -L -s -S $URL -o /dev/null) && \
    mkdir /config && \
    chown plex:plex /config && \
    dnf clean all && rm -rf /tmp/*

VOLUME /config
VOLUME /media

USER plex

EXPOSE 32400

ENV PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS 6
ENV PLEX_MEDIA_SERVER_MAX_STACK_SIZE 3000
ENV PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR /config
ENV PLEX_MEDIA_SERVER_HOME /usr/lib/plexmediaserver
ENV LD_LIBRARY_PATH /usr/lib/plexmediaserver
ENV TMPDIR /tmp

WORKDIR /usr/lib/plexmediaserver
CMD test -f /config/Plex\ Media\ Server/plexmediaserver.pid && rm -f /config/Plex\ Media\ Server/plexmediaserver.pid; \
    ulimit -s $PLEX_MAX_STACK_SIZE && ./Plex\ Media\ Server
