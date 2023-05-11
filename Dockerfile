FROM alpine:3.18

RUN apk add --no-cache curl bash wireguard-tools dante-server
ADD ["entry.sh", "wireguard.demo.conf", "sockd.default.conf", "/vpn/"]

# 监控检查在entry.sh中执行
# HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
# CMD curl -f http://localhost:1080/ || exit 1

ENV SOCKS5="off" \ 
    WG_PRIVATE_KEY= \
    WG_ADDRESS_KEY= \
    WG_PEER_ENDPOINT= \
    WG_PEER_PUBLIC_KEY= \
    WG_ADDRESS_DNS="1.1.1.1,8.8.8.8"\
    WG_ADDRESS_MTU= \
    WG_PEER_ALLOWED_IPS="0.0.0.0/0"\
    WG_PEER_SKIPPED_IPS= \
    WG_PEER_KEEPALIVE= \
    WG_CONF= \
    DANTE_CONF= \
    SUCC_SHELL= \
    HEALTH_URI= \
    TESTIP_URI="https://ipinfo.io"

ENTRYPOINT [ "bash", "/vpn/entry.sh" ]