# Plex container
# Version 0.9.12.11.1406-8403350

FROM debian:jessie

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/* \
    useradd --system --uid 797 -M --shell /usr/sbin/nologin plex \
    touch /bin/start \
    chmod +x /bin/start \
    DOWNLOAD_URL=`curl -Ls https://plex.tv/downloads | grep -o '[^"'"'"']*amd64.deb' | grep -v binaries` && \
    echo $DOWNLOAD_URL && \
    curl -L $DOWNLOAD_URL -o plexmediaserver.deb \
    dpkg -i plexmediaserver.deb \
    rm -f plexmediaserver.deb \
    rm -f /bin/start \
    mkdir /config \
    chown plex:plex /config

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
