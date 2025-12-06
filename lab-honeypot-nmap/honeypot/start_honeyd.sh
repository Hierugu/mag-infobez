#!/bin/bash
set -e

NET_IFACE="eth0"
NET_CIDR="172.16.238.0/24"
HOST_IP="172.16.238.10"

# Запускаем ARP-ответчик для сети honeypot
farpd -d -i "$NET_IFACE" "$NET_CIDR" &

# Запускаем honeyd, привязывая к интерфейсу и адресу хоста
honeyd -d -i "$NET_IFACE" -f /etc/honeypot/honeyd.conf -l /var/log/honeyd.log "$HOST_IP"