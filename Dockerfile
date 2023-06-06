FROM alpine:3.18

RUN apk add --no-cache curl bash jq openvpn 
ADD ["openvpn.demo.ovpn", "/vpn/"]

WORKDIR /vpn

# 监控检查在entry.sh中执行
# HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
# CMD curl -f http://localhost:1080/ || exit 1

ENV OV_USER_PASS= \
    OV_CONF_PATH=

ADD [ "entry", "dohip", "myip", "/usr/local/bin/" ]
CMD ["entry"]