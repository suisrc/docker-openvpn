FROM alpine:3.18

RUN apk add --no-cache curl bash openvpn dante-server
ADD ["openvpn.demo.ovpn", "sockd.default.conf", "/vpn/"]

WORKDIR /vpn

# 监控检查在entry.sh中执行
# HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
# CMD curl -f http://localhost:1080/ || exit 1

ENV SOCKS5="off" \ 
    OPVPN_AUTH= \
    OPVPN_CONF= \
    OPSKIP_IPS= \
    DANTE_CONF= \
    CONF_SHELL= \
    SUCC_SHELL= \
    EXIT_SHELL= \
    HEALTH_SHELL= \
    TESTIP_URI=

ADD [ "entry", "p2p", "dohip", "myip", "/usr/bin/" ]
CMD ["entry"]