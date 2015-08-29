# Plex container
# Version 0.9.12.11.1406-8403350

FROM fedora:latest

RUN useradd --system --uid 797 -M --shell /usr/sbin/nologin plex \
    DOWNLOAD_URL=`curl -skl https://plex.tv/downloads | grep -o '[^"'"'"']*.x86_64.rpm' | grep -v bin | uniq` && \
    curl -klo plex.rpm $DOWNLOAD_URL \
    rpm -ivh plex.rpm \
    rm -f plex.rpm \
    mkdir /config \
    chown plex:plex /config \
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
