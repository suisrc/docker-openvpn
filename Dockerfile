FROM alpine:3.17

RUN apk add --no-cache curl bash openvpn dante-server
ADD ["entry.sh", "openvpn.demo.ovpn", "sockd.default.conf", "/vpn/"]

# 监控检查在entry.sh中执行
# HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
# CMD curl -f http://localhost:1080/ || exit 1

ENV OPVPN_AUTH= \
    OPVPN_CONF= \
    DANTE_CONF= \
    HEALTH_URI= \
    ALLOWS_IPS=
ENTRYPOINT [ "bash", "/vpn/entry.sh" ]