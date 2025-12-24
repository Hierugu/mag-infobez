FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections \
  && echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections \
  && apt-get install -y --no-install-recommends \
    apache2 \
    libapache2-mod-security2 \
    iptables \
    iptables-persistent \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN a2enmod security2 || true

RUN mkdir -p /var/www/html && echo "<html><body><h1>WAF Victim</h1></body></html>" > /var/www/html/index.html

# Установка пакетов и зависимостей для Части 2 (WAF/OWASP CRS)
RUN apt-get update \
  && apt-get install -y --no-install-recommends git curl ca-certificates \
  && git clone https://github.com/coreruleset/coreruleset.git /tmp/coreruleset \
  && mkdir -p /etc/modsecurity \
  && cp /tmp/coreruleset/crs-setup.conf.example /etc/modsecurity/crs-setup.conf \
  && cp -R /tmp/coreruleset/rules/ /etc/modsecurity/ \
  && rm -f /etc/modsecurity/rules/REQUEST-922-MULTIPART-ATTACK.conf || true \
  \
  # Переименование конфига и включение режима блокировки
  && if [ -f /etc/modsecurity/modsecurity.conf-recommended ]; then \
       mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf; \
     fi \
  && sed -i 's/SecRuleEngine\s\+DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf || true \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY set-net-rules.sh /usr/local/bin/set-net-rules.sh
RUN chmod +x /usr/local/bin/set-net-rules.sh

EXPOSE 80

CMD ["bash", "-c", "tail -f /dev/null"]
