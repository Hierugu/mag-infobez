#!/bin/bash
NET_IFACE="eth0"
NET_CIDR="172.16.238.0/24"
ip link set dev $NET_IFACE promisc on
farpd -i $NET_IFACE $NET_CIDR &
sleep 1
honeyd -i $NET_IFACE -f /etc/honeypot/honeyd.conf &
tail -f /dev/null