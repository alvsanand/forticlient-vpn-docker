#!/bin/bash
set -e

ifconfig | grep "inet" >/tmp/ifconfig

echo "Starting squid..."
/etc/init.d/squid status || /etc/init.d/squid start

bash -c '
for (( ; ; ))
do
   ifconfig | grep "inet" > /tmp/ifconfig.new && \
   diff /tmp/ifconfig /tmp/ifconfig.new || ( \
       mv -f /tmp/ifconfig.new /tmp/ifconfig && /etc/init.d/squid restart && \
       echo "Detected network change, restarting squid...")
    sleep 5
done' &

echo "Starting fortisslvpn..."

cd /opt/forticlientsslvpn
./fortisslvpn.sh
