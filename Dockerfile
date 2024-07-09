FROM ubuntu:23.04

ADD https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 /usr/bin/ttyd
RUN chmod +x /usr/bin/ttyd

ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /sbin/tini
RUN chmod +x /sbin/tini

ARG BASE_DIR=/opt/apolo/web-shell
RUN mkdir -p $BASE_DIR

COPY requirements/apt.txt requirements/python.txt $BASE_DIR/
RUN apt-get update -qq && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -qq -y --no-install-recommends software-properties-common && \
    xargs -ra $BASE_DIR/apt.txt apt-get install -qq -y --no-install-recommends  && \
    ln -s $(which python3) /usr/bin/python && \
    python -m pip install -U pip --break-system-packages && \
    pip3 install -U --no-cache-dir -r $BASE_DIR/python.txt --break-system-packages  && \
    apt autoclean && apt autoremove -y --purge && rm -rf /var/lib/apt/lists/* && \
    rm $BASE_DIR/* && \
    echo alias apolo=neuro >> /root/.bashrc && \
    echo alias apolo-flow=neuro-flow >> /root/.bashrc && \
    echo alias apolo-extras=neuro-extras >> /root/.bashrc

EXPOSE 7681

ENV SHELL=/bin/bash WORKDIR=/root

COPY docker-entrypoint.sh apolo.readme $BASE_DIR/
RUN chmod +x $BASE_DIR/docker-entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/opt/apolo/web-shell/docker-entrypoint.sh"]
CMD ["ttyd", "screen", "-A", "-xR", "apolo"]
