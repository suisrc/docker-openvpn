#!/bin/bash

# bash wireguard.surfshark.sh la-vte

host=$1
if [[ $host != *.prod.surfshark.com ]]; then
    host=$host".prod.surfshark.com"
fi

# 读取server list for get public key
cat `dirname $0`/wireguard.surfshark.list | grep $host | while read line; do
    IFS=' ' read -r id connectionName publicKey tag location <<< "$line"
    if [[ ! ($tag == p* || $tag == v*)  ]]; then
        location=$tag" "$location
    fi

    if [[ "$2" == "ip" ]]; then
        ip=`curl -sSL -H 'Accept: application/dns-json' https://1.1.1.1/dns-query\?type\=A\&name\=$host \
          | jq '.Answer | to_entries[] | .value.data' | head -n 1 | sed 's/"//g'`
        echo "$ip $publicKey $location"
    else 
        echo "$host $publicKey $location"
    fi
    exit 0 # 只输出一信息即可
done
