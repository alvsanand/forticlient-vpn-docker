FROM ubuntu:16.04

ADD forticlientsslvpn.tgz /opt/

RUN apt-get update \
    && apt-get -y install build-essential chromium-browser curl curl expect iproute2 iptables jq libgtk2.0-0 net-tools ppp python3-venv squid ssh telnet vim wget

COPY squid.conf /etc/squid/squid.conf
RUN cp /etc/init.d/squid /etc/systemd/system/ \
    && systemctl enable squid

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp

ENTRYPOINT ["entrypoint.sh"]