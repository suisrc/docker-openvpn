#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

cleanup() {
    echo "cleaning wg0..."
    wg-quick down wg0
    exit 0
}

# if file is prefix http, download it.
if [[ $WG_CONF == http* ]]; then
    echo "downloading wireguard conf file: $WG_CONF"
    curl -ksSL "$WG_CONF" -o /vpn/wireguard.conf
    WG_CONF=/vpn/wireguard.conf
fi

# 如果WG_CONF不存在，通过环境变量创建
if [[ ! -f $WG_CONF ]]; then
    cat <<EOF > /vpn/wireguard.conf
[Interface]
PrivateKey = $WG_PRIVATE_KEY
Address = $WG_ADDRESS_KEY
DNS = $WG_ADDRESS_DNS

EOF
    if [[ -n $WG_ADDRESS_MTU ]]; then
        echo "MTU = $WG_ADDRESS_MTU" >> /vpn/wireguard.conf
    fi
    cat <<EOF >> /vpn/wireguard.conf

[Peer]
PublicKey = $WG_PEER_PUBLIC_KEY
AllowedIPs = $WG_PEER_ALLOWED_IPS
Endpoint = $WG_PEER_ENDPOINT

EOF
    if [[ -n $WG_PEER_KEEPALIVE ]]; then
        echo "PersistentKeepalive = $WG_PEER_KEEPALIVE" >> /vpn/wireguard.conf
    fi
    WG_CONF=/vpn/wireguard.conf
fi

ln -sf "$WG_CONF" /etc/wireguard/wg0.conf

# if file is prefix http, download it.
if [[ $DANTE_CONF == http* ]]; then
    echo "downloading dante conf file: $DANTE_CONF"
    curl -ksSL "$DANTE_CONF" -o /vpn/sockd.conf
    DANTE_CONF=/vpn/sockd.conf
fi
# Dante configuration file.
if [[ ! -f $DANTE_CONF ]]; then
    # default dante conf file.
    DANTE_CONF=/vpn/sockd.default.conf
fi

echo "using wireg conf file: $WG_CONF"
echo "using dante conf file: $DANTE_CONF"

wg-quick up wg0
# 如果没有/sys/class/net/wg0 文件启动失败，退出
if [[ ! -e /sys/class/net/wg0 ]]; then
    echo "wg0 not found, wireguard start failed."
    exit 1
fi
# 显示连接状况
wg show
echo ""
echo "wg0 has been install"


trap cleanup TERM

# 启动dante-socks5代理
if [[ "$PROXY_SOCK" == "on" ]]; then
    sockd -f "$DANTE_CONF" -D
fi

#=========================================================
# 成功启动后执行的脚本
if [[ -n "$SUCC_SHELL" ]]; then
  bash -c "$SUCC_SHELL"
fi
# 如果存在健康检查地址，就进行健康检查，否则等待openvpn进程结束
if [[ -z "$HEALTH_URI" ]]; then
    if [[ -n "$TESTIP_URI" ]]; then
        sleep 1
        echo "public ip: $(curl -ksSL $TESTIP_URI)"
    fi
    # monitor wg-quick down wg0
    while [ -e /sys/class/net/wg0 ]; do
        sleep 5 # 检查wg0是否卸载
    done
else
    while true; do
        xbody=$(curl -ksSL -w "=%{http_code}" "$HEALTH_URI")
        if [[ $xbody == *=200 ]]; then
            echo "health check success: $xbody"
        else
            echo "health check failed:  $xbody"
        fi
        sleep 30
    done
    # wg-quick down wg0
fi
echo "wg0 has been removed"
