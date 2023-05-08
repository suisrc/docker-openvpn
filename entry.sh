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
    DANTE_CONF=/vpn/sockd.default.conf
fi

echo "using openvpn conf file: $OPVPN_CONF"
echo "using openvpn auth file: $OPVPN_AUTH"
echo "using dante   conf file: $DANTE_CONF"

# Dante Running. -D: run as daemon
sockd -f "$DANTE_CONF" -D

# OpenVPN Running.
openvpn --config "$OPVPN_CONF" "--auth-user-pass" "$OPVPN_AUTH" &
# OpenVPN PID.
openvpn_pid=$!

trap cleanup TERM

wait $openvpn_pid