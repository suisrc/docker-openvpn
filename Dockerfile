FROM alpine:3.18

RUN apk add --no-cache curl bash jq wireguard-tools dante-server

# 修正一下wg-quick的问题，如果注解或者容器配置了 src_valid_mark 不需要必须特权模式下运行
# [[ $proto == -4 ]] && cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1
RUN sed -i "s/\[\[ \$proto == -4 ]]/\[\[ \$proto == -4 \&\& \$(sysctl net.ipv4.conf.all.src_valid_mark | awk '{print \$3}') != 1 ]]/g" /usr/bin/wg-quick

ADD ["wireguard.demo.conf", "sockd.default.conf", "/vpn/"]

WORKDIR /vpn

# 监控检查在entry.sh中执行
# HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
# CMD curl -f http://localhost:1080/ || exit 1

ENV SOCKS5="off" \ 
    WG_PRIVATE_KEY= \
    WG_ADDRESS_KEY= \
    WG_ADDRESS_DNS="1.1.1.1,8.8.8.8"\
    WG_ADDRESS_MTU= \
    WG_SKIPPED_IPS= \
    WG_PEER_ENDPOINT= \
    WG_PEER_PUBLIC_KEY= \
    WG_PEER_ALLOWED_IPS="0.0.0.0/1, 128.0.0.0/1"\
    WG_PEER_KEEPALIVE= \
    WG_CONF= \
    WG_CONF_SHELL= \
    DANTE_CONF= \
    SUCC_SHELL= \
    EXIT_SHELL= \
    HEALTH_SHELL= \
    HEALTH_URI= \
    TESTIP_URI=

# TESTIP_URI，获取本机IP的地址，可以使用以下地址
# https://cloudflare.com/cdn-cgi/trace
# https://ipinfo.io

ADD [ "entry", "p2p", "dohip", "myip", "wg-reload", "/usr/bin/" ]
CMD ["entry"]