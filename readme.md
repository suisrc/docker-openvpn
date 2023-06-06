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

容器镜像地址
```
docker.io/suisrc/openvpn
quay.io/suisrc/openvpn
```

## 其他分支说明

### wireguard

包含wireguard的client工具

容器镜像地址
```
docker.io/suisrc/wireguard
quay.io/suisrc/wireguard
```


### openwire

openwire: openvpn + wireguard 集成的client工具，集成dante代理工具  
在偶数分支上（比如0.0.2， 0.0.4， 0.0.6...）集成了xray代理工具

容器镜像地址
```
docker.io/suisrc/openwire
quay.io/suisrc/openwire
```


### xray

一种代理工具，注意，这里不提倡科学上网，只是认为其提供的socks等代理方式比较全才集成的， 而且是部分集成而不是全部。

容器镜像地址
```
docker.io/suisrc/xray
quay.io/suisrc/xray
```

