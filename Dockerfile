FROM ubuntu:16.04

ADD forticlientsslvpn.tgz /opt/
    
RUN apt-get update \
    && apt-get -y install expect wget net-tools telnet curl iproute2 ppp iptables ssh curl libgtk2.0-0 chromium-browser python3-venv build-essential jq squid

RUN sed -i "/^acl SSL_ports port 443/a acl SSL_ports port 22" "/etc/squid/squid.conf" \
    && sed -i "/^acl Safe_ports port 21/a acl Safe_ports port 22" "/etc/squid/squid.conf" \
    && sed -i -e "s/^http_access deny all/http_access allow all/" "/etc/squid/squid.conf" \
    && cp /etc/init.d/squid /etc/systemd/system/ \
    && systemctl enable squid

EXPOSE 3128/tcp

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]