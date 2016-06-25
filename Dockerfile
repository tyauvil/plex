FROM ubuntu:xenial

MAINTAINER Ty Auvil https://github.com/tyauvil

RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//mirror:\/\/mirrors.ubuntu.com\/mirrors.txt/' /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends wget && \
    wget --no-check-certificate "https://plex.tv/downloads/latest/1?channel=8&build=linux-ubuntu-x86_64&distro=ubuntu" -O /tmp/plex.deb && \
    wget --no-check-certificate "https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64.deb" -O /tmp/dumb-init.deb && \
    useradd --system --uid 797 -M --shell /usr/sbin/nologin plex && \
    dpkg -i /tmp/*.deb && \
    mkdir /config && \
    chown plex:plex /config && \
    rm -rf /tmp/* && \
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    apt-get clean all

VOLUME /config
VOLUME /media

USER plex

EXPOSE 32400

ENV PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS 6
ENV PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR /config
ENV PLEX_MEDIA_SERVER_HOME /usr/lib/plexmediaserver
ENV LD_LIBRARY_PATH /usr/lib/plexmediaserver
ENV TMPDIR /tmp

ADD docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
