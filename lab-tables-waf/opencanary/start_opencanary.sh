#!/bin/sh
set -e
mkdir -p /var/log/opencanary

# Start opencanary daemon using config in /etc/opencanaryd/opencanary.conf
# --dev runs in foreground to keep container alive
exec opencanaryd --dev
