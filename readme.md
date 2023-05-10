# 说明

openvpn + dante

## openvpn
openvpn是一个开源的VPN软件，可以用来创建点对点或者站点到站点的连接，它支持自定义安全协议以及混合模式的虚拟专用网络。

## dante
dante是一个SOCKS服务器，支持版本4和版本5，可以用来做代理服务器。

## 变量

WGVPN_AUTH:  wireguard 私钥
WGVPN_CONF:  wireguard 配置文件
DANTE_CONF:  dante 配置文件