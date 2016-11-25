FROM ubuntu:xenial

MAINTAINER Ty Auvil https://github.com/tyauvil

ENV DUMB_VERSION=1.2.0 \
    DEBIAN_FRONTEND=noninteractive \
    PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6 \
    PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/config \
    PLEX_MEDIA_SERVER_HOME=/usr/lib/plexmediaserver \
    LD_LIBRARY_PATH=/usr/lib/plexmediaserver \
    TMPDIR=/tmp

COPY docker-entrypoint.sh /bin/docker-entrypoint.sh
ADD https://github.com/Yelp/dumb-init/releases/download/v${DUMB_VERSION}/dumb-init_${DUMB_VERSION}_amd64 /bin/dumb-init

RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//mirror:\/\/mirrors.ubuntu.com\/mirrors.txt/' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends wget && \
    wget --no-check-certificate "https://plex.tv/downloads/latest/1?channel=8&build=linux-ubuntu-x86_64&distro=ubuntu" -O /tmp/plex.deb && \
    useradd --system --uid 797 -M --shell /usr/sbin/nologin plex && \
    dpkg -i /tmp/plex.deb && \
    mkdir /config && \
    chown plex:plex /config && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /bin/docker-entrypoint.sh /bin/dumb-init

VOLUME /config /media

USER plex

EXPOSE 32400

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
