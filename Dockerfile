FROM ubuntu:16.04

ADD forticlientsslvpn.tgz /opt/

RUN apt-get update \
    && apt-get -y install build-essential chromium-browser curl curl expect iproute2 iptables jq libgtk2.0-0 net-tools ppp python3-venv squid ssh telnet vim wget

RUN sed -i -e "/^acl SSL_ports port 443/a acl SSL_ports port 22" "/etc/squid/squid.conf" \
    && sed -i -e "/^acl SSL_ports port 22/a acl Safe_ports port 443" "/etc/squid/squid.conf" \
    && sed -i -e "/^acl SSL_ports port 22/a acl Safe_ports port 22" "/etc/squid/squid.conf" \
    && sed -i -e "/^acl SSL_ports port 22/a acl Safe_ports port 21" "/etc/squid/squid.conf" \
    && sed -i -e "s/^http_access deny all/http_access allow all/" "/etc/squid/squid.conf" \
    && echo "dns_v4_first on" >> "/etc/squid/squid.conf" \
    && cp /etc/init.d/squid /etc/systemd/system/ \
    && systemctl enable squid

EXPOSE 3128/tcp

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]