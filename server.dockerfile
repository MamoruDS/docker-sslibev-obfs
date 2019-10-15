FROM alpine:3.9 AS build-env

LABEL maintainer="mamoru <jlchen2015@gmail.com>"

RUN set -ex \
    && apk add --no-cache \
    autoconf \
    automake \
    build-base \
    c-ares-dev \
    libev-dev \
    libtool \
    libsodium-dev \
    linux-headers \
    mbedtls-dev \
    pcre-dev \
    gcc \
    make \
    zlib-dev \
    openssl \
    asciidoc \
    xmlto \
    libpcre32 \
    g++ \
    linux-headers \
    git
RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git \
    && git clone https://github.com/shadowsocks/simple-obfs.git

WORKDIR /shadowsocks-libev
RUN git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --prefix=/usr --disable-documentation \
    && make install

WORKDIR /simple-obfs
RUN git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure && make \
    && make install

FROM alpine:3.9

ENV ARGS ''
ENV OBFS_OPT ${OBFS_OPT:-'--plugin obfs-server --plugin-opts "obfs=http"'}

COPY --from=build-env /usr/bin/ss-server /usr/bin/ss-server
COPY --from=build-env /usr/local/bin/obfs-server /usr/local/bin/obfs-server
RUN apk add --no-cache \
        rng-tools \
        $(scanelf --needed --nobanner /usr/bin/ss-* \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u) \
        $(scanelf --needed --nobanner /usr/local/bin/obfs-* \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u) \
    && echo '{' > config.json \
    && echo '    "server": "0.0.0.0",' >> config.json \
    && echo '    "server_port": "8388",' >> config.json \
    && echo '    "password": "mypassword",' >> config.json \
    && echo '    "timeout": 300,' >> config.json \
    && echo '    "method": "aes-256-cfb",' >> config.json \
    && echo '    "fast_open": false' >> config.json \
    && echo '}' >> config.json
USER nobody

CMD ss-server -c config.json ${ARGS} ${OBFS_OPT}