FROM fedora:22

ENV plexrpm='https://downloads.plex.tv/plex-media-server/0.9.12.18.1520-6833552/plexmediaserver-0.9.12.18.1520-6833552.x86_64.rpm'

RUN useradd --system --uid 797 -M --shell /usr/sbin/nologin plex && \
    rpm -ivh $plexrpm && \
    mkdir /config && \
    chown plex:plex /config && \
    dnf clean all

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
