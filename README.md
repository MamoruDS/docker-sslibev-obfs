# docker-sslibev-obfs
> Using shadowsocks-libev & simple-obfs with Docker.

![docker](https://img.shields.io/docker/pulls/mamoruio/docker-sslibev-obfs.svg?style=flat-square) ![size](https://img.shields.io/microbadger/image-size/mamoruio/docker-sslibev-obfs/19528k1-server.svg?style=flat-square) ![layer](https://img.shields.io/microbadger/layers/mamoruio/docker-sslibev-obfs/19528k1-server.svg?style=flat-square)

## Issue
Unknown issue: obfs do not work with Docker 18.03

## Intro
This image let you simply deploy shadowsocks with obfs on your server.  

Shadowsocks-libev is a lightweight secured SOCKS5 proxy for embedded devices and low-end boxes. Get more info by visiting this [page](https://github.com/shadowsocks/shadowsocks-libev).  

Simple-obfs is a simple obfusacting tool, designed as plugin server of shadowsocks. Get more info by visiting this [page](https://github.com/shadowsocks/simple-obfs).
## Usage
Quick start:
```shell
docker run -it \
    --name ss \
    -p 8388:8388 \
    --restart always \
    mamoruio/docker-sslibev-obfs:server
```
### options
#### start options
Get options' info by reading shadowsocks-libev's [doc](https://github.com/shadowsocks/shadowsocks-libev/blob/master/doc/ss-server.asciidoc).
```shell
docker run -it \
    --name ss \
    -e ARGS='-p 1080 -k passwd -m chacha20-ietf-poly1305 --fast-open' \
    -p 41080:1080 \
    --restart always \
    mamoruio/docker-sslibev-obfs:server
```
`--fast-open` maybe not working cause kernel-headers' issue.
#### obfs options
obfs with tls
```shell
docker run -it \
    --name ss \
    -e OBFS_OPT='--plugin obfs-server --plugin-opts "obfs=tls"' \
    -p 8388:8388 \
    --restart always \
    mamoruio/docker-sslibev-obfs:server
```
disable obfs  
```shell
docker run -it \
    --name ss \
    -e OBFS_OPT=' ' \
    -p 8388:8388 \
    --restart always \
    mamoruio/docker-sslibev-obfs:server
```
#### custom config.json
Check this [page](https://github.com/shadowsocks/shadowsocks/wiki/Configuration-via-Config-File) for getting more info about shadowsocks' configuration file.  

You can mount your configuration file by following:  
```shell
docker run -it \
    --name ss \
    -v $docker_mnt/config.json:/config.json \
    -p 8388:8388 \
    --restart always \
    mamoruio/docker-sslibev-obfs:server
```
Aslo worked with other options:  
```shell
docker run -it \
    --name ss \
    -v $docker_mnt/config.json:/config.json \
    -e OBFS_OPT='--plugin obfs-server --plugin-opts "obfs=tls"' \
    -p 8388:8388 \
    --restart always \
    mamoruio/docker-sslibev-obfs:server
```
```shell
docker run -it \
    --name ss \
    -v $docker_mnt/config.json:/config.json \
    -e ARGS='-u' \
    -e OBFS_OPT='--plugin obfs-server --plugin-opts "obfs=tls"' \
    -p 8388:8388 \
    --restart always \
    mamoruio/docker-sslibev-obfs:server
```
## License
MIT © MamoruDS