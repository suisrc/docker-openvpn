FROM alpine:3.18

RUN apk add --no-cache curl bash jq iptables wireguard-tools inotify-tools

# ?? ip6tables nftables

# 修正一下wg-quick的问题，如果注解或者容器配置了 src_valid_mark 不需要必须特权模式下运行
# [[ $proto == -4 ]] && cmd sysctl -q net.ipv4.conf.all.src_valid_mark=1
RUN sed -i "s/\[\[ \$proto == -4 ]]/\[\[ \$proto == -4 \&\& \$(sysctl net.ipv4.conf.all.src_valid_mark | awk '{print \$3}') != 1 ]]/g" /usr/bin/wg-quick

ADD ["wg0.conf", "wg1.conf", "/vpn/"]

WORKDIR /vpn

ENV WG_CONF_SHELL=\
    INOTIFY_EVENT="create"

ADD [ "entry", "dohip", "myip", "wg-reload", "/usr/local/bin/" ]
CMD ["entry"]

STOPSIGNAL SIGINT