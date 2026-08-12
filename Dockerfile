FROM python:3.14.0-slim-trixie@sha256:0aecac02dc3d4c5dbb024b753af084cafe41f5416e02193f1ce345d671ec966e

ADD https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 /usr/bin/ttyd
RUN chmod +x /usr/bin/ttyd

ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /usr/sbin/tini
RUN chmod +x /usr/sbin/tini

ARG BASE_DIR=/opt/apolo/web-shell
RUN mkdir -p $BASE_DIR

COPY requirements/apt.txt requirements/python.txt $BASE_DIR/
RUN apt-get update -qq && \
    export DEBIAN_FRONTEND=noninteractive && \
    xargs -ra $BASE_DIR/apt.txt apt-get install -qq -y --no-install-recommends  && \
    python -m pip install -U --no-cache-dir -r $BASE_DIR/python.txt && \
    apt autoclean && apt autoremove -y --purge && rm -rf /var/lib/apt/lists/* && \
    rm $BASE_DIR/*

EXPOSE 7681

ENV SHELL=/bin/bash WORKDIR=/root

COPY docker-entrypoint.sh apolo.readme $BASE_DIR/
RUN chmod +x $BASE_DIR/docker-entrypoint.sh

ENTRYPOINT ["/usr/sbin/tini", "--", "/opt/apolo/web-shell/docker-entrypoint.sh"]
CMD ["ttyd", "screen", "-A", "-xR", "apolo"]
