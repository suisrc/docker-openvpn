# 说明

openvpn + dante

## openvpn
openvpn是一个开源的VPN软件，可以用来创建点对点或者站点到站点的连接，它支持自定义安全协议以及混合模式的虚拟专用网络。

## dante
dante是一个SOCKS服务器，支持版本4和版本5，可以用来做代理服务器。

## 变量

ENV SOCKS5="off" \ # 内部代理  
    OPVPN_AUTH= \  # 认证信息, user:pass  
    OPVPN_CONF= \  # 配置文件, file or uri
    OPSKIP_IPS= \  # 跳过的IP, 内部局域网IP
    DANTE_CONF= \  # socks5配置文件, file or uri
    SUCC_SHELL= \  # 启动成功后执行的命令
    HEALTH_URI= \  # 健康检查接口，不推荐使用
    TESTIP_URI="https://ipinfo.io"