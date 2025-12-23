#!/bin/sh
set -e
mkdir -p /var/log/opencanary

# Start opencanary daemon using default config path
# opencanaryd reads /etc/opencanaryd/opencanary.conf by default
# Use --dev to run in foreground (keeps container alive; --start would daemonize and exit)
exec opencanaryd --dev
