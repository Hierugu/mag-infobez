#!/bin/bash
set -e

cat > /etc/shorewall/rules <<'EOF'
# Allow ping
Ping(ACCEPT)  net  fw
Ping(ACCEPT)  dmz  fw
# Allow only specific services from net to dmz
ACCEPT   net   dmz   tcp   21,80,8080
EOF

cat > /etc/shorewall/policy <<'EOF'
fw   net   ACCEPT
fw   dmz   ACCEPT
dmz  net   ACCEPT
net  dmz   DROP   info
dmz  fw    ACCEPT
net  fw    ACCEPT
all  all   DROP   info
EOF

shorewall reload || shorewall restart
