FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    shorewall \
    iptables \
    iproute2 \
    rsyslog \
    procps \
    tcpdump \
    iputils-ping \
    ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY start_firewall.sh /usr/local/bin/start_firewall.sh
COPY close_firewall.sh /usr/local/bin/close_firewall.sh
RUN chmod +x /usr/local/bin/start_firewall.sh /usr/local/bin/close_firewall.sh

CMD ["/usr/local/bin/start_firewall.sh"]
