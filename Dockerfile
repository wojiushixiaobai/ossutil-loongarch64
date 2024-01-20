FROM golang:1.21-buster as builder

ARG VERSION=v1.7.18

RUN set -ex \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-get update \
    && apt-get install -y zip unzip \
    && rm -rf /var/lib/apt/lists/*

ARG WORKDIR=/opt/ossutil

RUN set -ex \
    && git clone -b ${VERSION} --depth=1 https://github.com/aliyun/ossutil ${WORKDIR}

ADD build_all.sh ${WORKDIR}/scripts/build_all.sh

WORKDIR ${WORKDIR}

RUN set -ex \
    && go mod download \
    && go get -u golang.org/x/sys \
    && bash scripts/build_all.sh

FROM debian:buster-slim

WORKDIR /opt/ossutil

COPY --from=builder /opt/ossutil/dist /opt/ossutil/dist

VOLUME /dist

CMD cp -rf dist/* /dist/