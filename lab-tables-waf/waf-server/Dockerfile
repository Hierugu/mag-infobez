FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apache2 \
    libapache2-mod-security2 \
    git \
    curl \
    ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN a2enmod security2 || true

RUN mkdir -p /var/www/html && echo "<html><body><h1>WAF Server (ModSecurity + CRS)</h1></body></html>" > /var/www/html/index.html

# Установка OWASP CRS
RUN git clone https://github.com/coreruleset/coreruleset.git /tmp/coreruleset \
  && mkdir -p /etc/modsecurity \
  && cp /tmp/coreruleset/crs-setup.conf.example /etc/modsecurity/crs-setup.conf \
  && cp -R /tmp/coreruleset/rules/ /etc/modsecurity/ \
  && rm -f /etc/modsecurity/rules/REQUEST-922-MULTIPART-ATTACK.conf || true \
  && if [ -f /etc/modsecurity/modsecurity.conf-recommended ]; then \
       mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf; \
     fi \
  && sed -i 's/SecRuleEngine\s\+DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf || true

WORKDIR /root

EXPOSE 80

CMD ["bash", "-c", "service apache2 start && tail -f /dev/null"]
