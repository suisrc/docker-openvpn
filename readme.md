# 说明

wireguard + dante

## wireguard
wireguard是一个VPN软件，支持linux、windows、macos、android、ios等平台，可以用来做VPN服务器。

## dante
dante是一个SOCKS服务器，支持版本4和版本5，可以用来做代理服务器。

## 变量

ENV SOCKS5="off" \    # 是否启用socks5代理  
    WG_PRIVATE_KEY= \ # wireguard私钥  
    WG_ADDRESS_KEY= \ # wireguard地址  
    WG_PEER_ENDPOINT= \    # wireguard对端地址  
    WG_PEER_PUBLIC_KEY= \  # wireguard对端公钥  
    WG_ADDRESS_DNS="1.1.1.1,8.8.8.8"\ # wireguard地址dns  
    WG_ADDRESS_MTU= \                 # wireguard网卡mtu  
    WG_PEER_ALLOWED_IPS="0.0.0.0/0"\  # wireguard对端允许的ip  
    WG_PEER_SKIPPED_IPS= \            # wireguard对端跳过的ip(暂未支持)  
    WG_PEER_KEEPALIVE= \              # wireguard对端保持连接  
    WG_CONF= \     # 配置文件，可取代上面的配置  
    DANTE_CONF= \  # socks5代理应用  
    SUCC_SHELL= \  # 成功后执行的脚本  
    HEALTH_URI= \  # 健康检查地址， 不推荐使用  
    TESTIP_URI="https://ipinfo.io"