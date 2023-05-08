FROM alpine:3.17

RUN apk add --no-cache curl bash openvpn dante

COPY *.sh /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh && mkdir -p /vpn/log/
ADD ["openvpn.demo.ovpn", "sockd.default.conf", "/vpn/"]

ENTRYPOINT [ "entry.sh" ]