FROM alpine:3.17

RUN apk add --no-cache curl bash openvpn dante-server
ADD ["entry.sh", "openvpn.demo.ovpn", "sockd.default.conf", "/vpn/"]

# 监控检查在entry.sh中执行
# HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
# CMD curl -f http://localhost:1080/ || exit 1

ENV PROXY_SOCK=on \ 
    OPVPN_AUTH= \
    OPVPN_CONF= \
    ALLOWS_IPS= \
    DANTE_CONF= \
    SUCC_SHELL= \
    HEALTH_URI= \
    TESTIP_URI="https://ipinfo.io"
ENTRYPOINT [ "bash", "/vpn/entry.sh" ]