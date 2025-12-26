FROM python:3.8-slim

RUN apt-get update && apt-get install -y --no-install-recommends dos2unix && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir opencanary

# ensure config dir exists and copy configuration + start script
RUN mkdir -p /etc/opencanaryd
COPY opencanary.conf /etc/opencanaryd/opencanary.conf
COPY start_opencanary.sh /usr/local/bin/start_opencanary.sh
RUN dos2unix /etc/opencanaryd/opencanary.conf /usr/local/bin/start_opencanary.sh && chmod +x /usr/local/bin/start_opencanary.sh

# Expose common honeypot ports (informational)
EXPOSE 21 22 23 25 53 80 110 139 143 443 3306 3389 445 5900 5988 8080

CMD ["/usr/local/bin/start_opencanary.sh"]
