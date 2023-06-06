# 说明

wireguard

## wireguard
wireguard是一个VPN软件，支持linux、windows、macos、android、ios等平台，可以用来做VPN服务器。

WG_CONF_PATH: 配置文件的位置
```
[Interface]
PrivateKey = <insert_your_private_key_here>
Address = <insert_your_ip_here>
DNS = <insert_your_dns_here>

[Peer]
PublicKey = <insert_server_public_key_here>
AllowedIPs = <insert_server_ip_here>
Endpoint = <insert_server_endpoint_here>
PersistentKeepalive = 25

```