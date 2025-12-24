#!/bin/bash
set -e

NET_IFACE="${NET_IFACE:-eth0}"
NET_CIDR="${NET_CIDR:-172.30.0.0/24}"
FIREWALL_IP="${FIREWALL_IP:-172.30.0.254}"
WAZUH_HOST="${WAZUH_HOST:-172.30.0.60}"

ip route replace default via "$FIREWALL_IP" dev "$NET_IFACE"
ip link set dev "$NET_IFACE" promisc on

echo "*.* @${WAZUH_HOST}:514" > /etc/rsyslog.d/90-remote.conf
service rsyslog restart || rsyslogd

farpd -d &
sleep 1
honeyd -d -f /etc/honeypot/honeyd.conf "$NET_CIDR" &
tail -f /dev/null
