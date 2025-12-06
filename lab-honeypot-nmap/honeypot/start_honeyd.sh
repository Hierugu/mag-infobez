#!/bin/bash
NET_IFACE="eth0"
NET_CIDR="172.16.238.0/24"
ip link set dev $NET_IFACE promisc on
farpd -d &
sleep 1
honeyd -d -f /etc/honeypot/honeyd.conf 172.16.238.0/24 &
tail -f /dev/null