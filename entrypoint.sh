#!/bin/bash
set -e

echo "Starting squid..."
/etc/init.d/squid status || /etc/init.d/squid start

echo "Starting fortisslvpn..."  
cd /opt/forticlient
./fortisslvpn.sh
