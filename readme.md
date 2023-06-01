# 说明

openvpn + wireguard + dante

## openvpn
openvpn是一个开源的VPN软件，可以用来创建点对点或者站点到站点的连接，它支持自定义安全协议以及混合模式的虚拟专用网络。

## wireguard
wireguard是一个开源的VPN软件，它是一个内核模块，可以用来创建点对点或者站点到站点的连接，它支持自定义安全协议以及混合模式的虚拟专用网络。

## dante
dante是一个SOCKS服务器，支持版本4和版本5，可以用来做代理服务器。

## docker

openwire => open(vpn) + wire(guard) 

suisrc/openwire
quay.io/suisrc/openwire

## surfshark

容器对surfshark进行了支持

docker run --rm -it \
-e SOCKS5=on \
-e VPN_TYPE=openvpn-surfshark \
-e VPN_REGION="la-vte ip" \
-e OV_USER_PASS="user:pass" \
suisrc/openwire:0.0.1


docker run --rm -it \
-e SOCKS5=on \
-e VPN_TYPE=wireguard-surfshark \
-e VPN_REGION="la-vte ip" \
-e WG_PRIVATE_KEY="xxx" \
suisrc/openwire:0.0.1

## 变量

ENV SOCKS5="off" \ # 是否启用socks5代理  
    DANTE_CONF= \  # dante配置文件路径  
    VPN_TYPE= openvpn\ # vpn类型  
    VPN_REGION= \      # vpn区域  
    VPN_PORT= \        # 1194/UDP(openvpn), 51820(wireguard)
    SKIPPED_IPS= \  # 不走代理的IP列表
    OV_USER_PASS= \  # openvpn用户名密码, user:pass or file_path  
    OV_CONF_PATH= \  # openvpn配置文件路径  
    OV_CONF_SHELL= \  # openvpn配置文件生成脚本， 初始配置文件 
    OV_CONF_SHEND= \  # openvpn配置文件生成脚本， 修复配置文件   
    WG_PRIVATE_KEY= \  # wireguard私钥  
    WG_ADDRESS_KEY= \  # wireguard地址  
    WG_ADDRESS_DNS="1.1.1.1,8.8.8.8"\  # wireguard DNS  
    WG_ADDRESS_MTU= \  # wireguard MTU  
    WG_PEER_ENDPOINT= \  # wireguard 对端地址  
    WG_PEER_PUBLIC_KEY= \  # wireguard 对端公钥  
    WG_PEER_ALLOWED_IPS="0.0.0.0/0"\  # wireguard 对端允许的IP  
    WG_PEER_KEEPALIVE= \  # wireguard 对端心跳  
    WG_CONF_PATH= \  # wireguard 配置文件路径  
    WG_CONF_SHELL= \  # wireguard 配置文件生成脚本， 初始配置文件  
    WG_CONF_SHEND= \  # wireguard 配置文件生成脚本， 修复配置文件
    SUCC_SHELL= \  # 成功后执行的脚本  
    EXIT_SHELL= \  # 退出后执行的脚本  
    HEALTH_SHELL= \  # 健康检查脚本  
    HEALTH_URI= \  # 健康检查地址  
    TESTIP_URI=  # 测试IP地址
