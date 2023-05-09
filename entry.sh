#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

cleanup() {
    kill TERM "$openvpn_pid"
    exit 0
}

# OpenVPN OPVPN_AUTH include ":", is user:pass, wirte to file
if [[ $OPVPN_AUTH == *:* ]]; then
    echo "$OPVPN_AUTH" | tr ':' '\n' > /vpn/auth.txt
    OPVPN_AUTH=/vpn/auth.txt
fi
# OpenVPN auth file.
if [[ ! -f $OPVPN_AUTH ]]; then
    echo "openvpn auth file not found: $OPVPN_AUTH" >&2
    exit 1
fi

# if file is prefix http, download it.
if [[ $OPVPN_CONF == http* ]]; then
    echo "downloading openvpn conf file: $OPVPN_CONF" >&2
    curl -ksSL "$OPVPN_CONF" -o /vpn/openvpn.conf
    OPVPN_CONF=/vpn/openvpn.conf
fi
# OpenVPN configuration file.
if [[ ! -f $OPVPN_CONF ]]; then
    echo "openvpn conf file not found: $OPVPN_CONF" >&2
    exit 1
fi

# if file is prefix http, download it.
if [[ $DANTE_CONF == http* ]]; then
    echo "downloading dante conf file: $DANTE_CONF" >&2
    curl -ksSL "$DANTE_CONF" -o /vpn/sockd.conf
    DANTE_CONF=/vpn/sockd.conf
fi
# Dante configuration file.
if [[ ! -f $DANTE_CONF ]]; then
    # default dante conf file.
    DANTE_CONF=/vpn/sockd.default.conf
fi

echo "using openvpn conf file: $OPVPN_CONF"
echo "using openvpn auth file: $OPVPN_AUTH"
echo "using dante   conf file: $DANTE_CONF"

mkdir /vpn/log

# 处理ALLOWS_IPS
if [[ -n "$ALLOWS_IPS" ]]; then
    echo "using openvpn allows ips: $ALLOWS_IPS"
    echo "$ALLOWS_IPS" | tr ',' '\n' | while read -r line; do
        echo "route $line net_gateway" >> "$OPVPN_CONF"
    done
fi

# OpenVPN Running.
openvpn --config "$OPVPN_CONF" "--auth-user-pass" "$OPVPN_AUTH" &
# OpenVPN PID.
openvpn_pid=$!

trap cleanup TERM

# Dante Running. -D: run as daemon
# sockd -f "$DANTE_CONF" -D
# 延迟10s启动dante代理(因为代理出口使用tun0，需要等待openvpn启动完成)
if [[ "$PROXY_SOCK" == "on" ]]; then
    sleep 10
    sockd -f "$DANTE_CONF" -D
fi

# wait $openvpn_pid

#=========================================================
# 成功启动后执行的脚本
if [[ -n "$SUCC_SHELL" ]]; then
  bash -c "$SUCC_SHELL"
fi
# 如果存在健康检查地址，就进行健康检查，否则等待openvpn进程结束
if [[ -z "$HEALTH_URI" ]]; then
    wait $openvpn_pid
else
    while true; do
        sleep 30
        xbody=$(curl -ksSL -w "=%{http_code}" "$HEALTH_URI")
        if [[ $xbody == *=200 ]]; then
            echo "health check success: $xbody" >&2
        else
            echo "health check failed:  $xbody" >&2
        fi
    done
fi