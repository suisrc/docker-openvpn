# 说明

这就是一个简单的open工具，不提供任何额外的功能，需要需要功能扩展，推荐 openwire 分支内容  
openwire： openvpn + wireguard 集成的client工具，甚至集成了xray, dante等代理工具等  

OV_USER_PASS: 认证文件的位置  
```
username
password
```

OV_CONF_PATH: 配置文件的位置  
```
client
dev tun
proto udp
remote example.com 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert client.crt
key client.key
comp-lzo
verb 3
log /vpn/log/openvpn.log
```
