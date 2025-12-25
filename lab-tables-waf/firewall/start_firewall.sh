#!/bin/bash
set -e

WAN_IFACE="${WAN_IFACE:-eth0}"
DMZ_IFACE="${DMZ_IFACE:-eth1}"
DMZ_NET="${DMZ_NET:-172.30.0.0/24}"
WAN_NET="${WAN_NET:-172.29.0.0/24}"
WAZUH_HOST="${WAZUH_HOST:-172.30.0.60}"

# Не отключаем imklog - нужен для чтения kernel logs (iptables LOG)
# sed -i '/^module(load="imklog"/s/^/#/' /etc/rsyslog.conf || true

echo "*.* @${WAZUH_HOST}:514" > /etc/rsyslog.d/90-remote.conf
rsyslogd -n &
SYSLOG_PID=$!
sleep 1

sysctl -w net.ipv4.ip_forward=1 2>/dev/null || echo "1" > /proc/sys/net/ipv4/ip_forward || true

mkdir -p /etc/shorewall

cat > /etc/shorewall/shorewall.conf <<'EOF'
STARTUP_ENABLED=Yes
IP_FORWARDING=On
LOGFILE=/var/log/messages
LOG_MARTIANS=Yes
BLACKLIST_LOGLEVEL=info
LOGALLNEW=info
MACLIST_LOG_LEVEL=info
TC_ENABLED=Internal
ACCOUNTING=Yes
ACCOUNTING_TABLE=filter
EOF

cat > /etc/shorewall/zones <<'EOF'
fw   firewall
net  ipv4
dmz  ipv4
EOF

cat > /etc/shorewall/interfaces <<EOF
net  ${DMZ_IFACE}
dmz  ${WAN_IFACE}
EOF

cat > /etc/shorewall/policy <<'EOF'
fw   net   ACCEPT
fw   dmz   ACCEPT
dmz  net   ACCEPT
net  dmz   ACCEPT
dmz  fw    ACCEPT
net  fw    ACCEPT
all  all   DROP   info
EOF

cat > /etc/shorewall/rules <<'EOF'
# Allow syslog from firewall to Wazuh
ACCEPT:info   fw    dmz   udp   514
# Allow ping
Ping(ACCEPT:info)  net  fw
Ping(ACCEPT:info)  dmz  fw
# Test logging rule - логируем все соединения на порты 1-1024
LOG:info   net   dmz   tcp   1:1024
LOG:info   dmz   net   tcp   1:1024
# Allow HTTP/HTTPS from net to dmz (honeypot) with logging
ACCEPT:info   net   dmz   tcp   80,443
# Allow SSH from net to dmz (optional labs) with logging
ACCEPT:info   net   dmz   tcp   22
# Log dropped packets
?SECTION NEW
DROP:info    all   all   all   -   -   -
EOF

cat > /etc/shorewall/masq <<EOF
${WAN_IFACE}  ${DMZ_NET}
EOF

cat > /etc/shorewall/routestopped <<'EOF'
net     0.0.0.0/0
dmz     0.0.0.0/0
EOF

shorewall check
shorewall restart

# Убедимся, что логи пишутся
echo "Shorewall настроен с логированием. Логи можно просмотреть:"
echo "tail -f /var/log/syslog | grep Shorewall"
echo "или"
echo "shorewall show log"

tail -f /var/log/syslog | grep -E "Shorewall|shorewall"