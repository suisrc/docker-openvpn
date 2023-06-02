FROM alpine:3.18 as builder

ARG RAY_VERSION=1.8.1

RUN apk add --no-cache curl p7zip ca-certificates

# https://github.com/XTLS/Xray-core/releases/download/v?.?.?/Xray-linux-64.zip
RUN RAY_RURL="https://github.com/XTLS/Xray-core/releases" &&\
    RAY_URL="${RAY_RURL}/download/v${RAY_VERSION}/Xray-linux-64.zip" &&\
    curl -L -o /tmp/xray.zip ${RAY_URL} &&\
    7z x /tmp/xray.zip -o/tmp &&\
    chmod +x /tmp/xray


FROM alpine:3.18 as runner

LABEL maintainer="suisrc@outlook.com"

RUN apk add --no-cache tzdata  ca-certificates &&\
    mkdir -p /var/log/xray /usr/share/xray /etc/xray/

COPY --from=builder /tmp/xray /usr/local/bin/xray
COPY --from=builder /tmp/geoip.dat /usr/share/xray/geoip.dat
COPY --from=builder /tmp/geosite.dat /usr/share/xray/geosite.dat
COPY config.json /etc/xray/config.json

ENV TZ=Asia/Shanghai
CMD [ "xray", "-config", "/etc/xray/config.json" ]
