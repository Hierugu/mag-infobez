FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections \
  && echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections \
  && apt-get install -y --no-install-recommends \
    apache2 \
    iptables \
    iptables-persistent \
    iproute2 \
    dos2unix \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && echo "<html><body><h1>IPTables Server</h1></body></html>" > /var/www/html/index.html

WORKDIR /root

COPY set-net-rules.sh /usr/local/bin/set-net-rules.sh
RUN dos2unix /usr/local/bin/set-net-rules.sh && chmod +x /usr/local/bin/set-net-rules.sh

EXPOSE 80

CMD ["bash", "-c", "service apache2 start && tail -f /dev/null"]
