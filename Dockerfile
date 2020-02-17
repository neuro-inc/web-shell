FROM ubuntu:18.04

ADD https://github.com/tsl0922/ttyd/releases/download/1.5.2/ttyd_linux.x86_64 /usr/bin/ttyd
RUN chmod +x /usr/bin/ttyd

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /sbin/tini
RUN chmod +x /sbin/tini

ARG BASE_DIR=/opt/neuro/web-shell
RUN mkdir -p $BASE_DIR

COPY requirements.txt $BASE_DIR
RUN apt update && apt install -y \
    build-essential git screen python3.7-dev python3-pip && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1 && \
    python -m pip install -r $BASE_DIR/requirements.txt

EXPOSE 7681

ENV SHELL=/bin/bash

COPY docker-entrypoint.sh $BASE_DIR
COPY neuro.readme $BASE_DIR/readme
RUN chmod +x $BASE_DIR/docker-entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/opt/neuro/web-shell/docker-entrypoint.sh"]
CMD ["ttyd", "screen", "-A", "-xR", "neuro"]
