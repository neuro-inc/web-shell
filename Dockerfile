FROM ubuntu:21.10

ADD https://github.com/tsl0922/ttyd/releases/download/1.5.2/ttyd_linux.x86_64 /usr/bin/ttyd
RUN chmod +x /usr/bin/ttyd

ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /sbin/tini
RUN chmod +x /sbin/tini

ARG BASE_DIR=/opt/neuro/web-shell/
RUN mkdir -p $BASE_DIR

COPY requirements/apt.txt requirements/python.txt $BASE_DIR
RUN apt update -qq && \
    cat $BASE_DIR/apt.txt | tr -d "\r" | xargs -I % apt install -qq -y --no-install-recommends % && \
    ln -s $(which python3.8) /usr/bin/python && \
    python3.8 -m pip install -U pip && \
    pip3 install -U --no-cache-dir -r $BASE_DIR/python.txt && \
    apt autoclean && apt autoremove -y --purge && rm -rf /var/lib/apt/lists/* && \
    rm $BASE_DIR/*

EXPOSE 7681

ENV SHELL=/bin/bash WORKDIR=/root

COPY docker-entrypoint.sh neuro.readme $BASE_DIR
RUN chmod +x $BASE_DIR/docker-entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--", "/opt/neuro/web-shell/docker-entrypoint.sh"]
CMD ["ttyd", "screen", "-A", "-xR", "neuro"]
