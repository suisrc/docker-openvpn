# FROM suisrc/xray:1.8.1 
# # alpine:3.18 | suisrc/xray:1.8.1 
# # 版本单数使用base， 双数使用xray
# 
# # f1.json,f2.json...可以同时启动多个xray服务
# ENV XRAY_CONF= \
#     XRAY_KEY= \
#     XRAY_CNS= \
#     XRAY_TMPL= \
#     XRAY_LOC0=on \
#     XRAY_PORT=9000 \
#     XRAY_AUTO=off

FROM alpine:3.18
LABEL maintainer="suisrc@outlook.com"

RUN apk add --no-cache \
    curl jq bash \
    openvpn \
    wireguard-tools \
    dante-server \
    && rm -rf /var/cache/apk/*

# 修正一下wg-quick的问题，如果注解或者容器配置了 src_valid_mark 不需要必须特权模式下运行
# [[ $proto == -4 ]] && cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1
RUN sed -i "s/\[\[ \$proto == -4 ]]/\[\[ \$proto == -4 \&\& \$(sysctl net.ipv4.conf.all.src_valid_mark | awk '{print \$3}') != 1 ]]/g" /usr/bin/wg-quick

ADD [ "bin/*", "/usr/local/bin/" ]
ADD ["openvpn.*", "wireguard.*", "providers/", "/vpn/"]

ENV SOCKS5=off \ 
    DANTE_CONF= \
    VPN_TYPE= \
    VPN_KEY=a01 \
    VPN_REGION= \
    SKIPPED_IPS= \
    OV_USER_PASS= \
    OV_CONF_PATH= \
    OV_CONF_SHELL= \
    OV_CONF_SHEND= \
    WG_PRIVATE_KEY= \
    WG_ADDRESS_KEY= \
    WG_ADDRESS_DNS="1.1.1.1,8.8.8.8" \
    WG_ADDRESS_MTU= \
    WG_PEER_ENDPOINT= \
    WG_PEER_PUBLIC_KEY= \
    WG_PEER_ALLOWED_IPS="0.0.0.0/0" \
    WG_PEER_KEEPALIVE= \
    WG_CONF_PATH= \
    WG_CONF_SHELL= \
    WG_CONF_SHEND= \
    SUCC_SHELL= \
    EXIT_SHELL= \
    HEALTH_SHELL= \
    HEALTH_URI= \
    TESTIP_URI=

# TESTIP_URI，获取本机IP的地址，可以使用以下地址
# https://cloudflare.com/cdn-cgi/trace
# https://ipinfo.io

WORKDIR /vpn
CMD ["vpn-entry"]

# 监控检查在entry.sh中执行
# HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
# CMD curl -f http://localhost:1080/ || exit 1
