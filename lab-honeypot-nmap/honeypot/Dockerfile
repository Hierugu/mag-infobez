FROM hadang/ubuntu12.04-honeyd

# Обновляем источники на архивные репозитории для Ubuntu Precise
RUN sed -i 's/archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

# Установка dos2unix для конвертации строк
RUN apt-get update && \
    apt-get install -y dos2unix nmap inetutils-ping && \
    rm -rf /var/lib/apt/lists/*

# Настройка Honeyd конфигурации
RUN mkdir -p /etc/honeypot
COPY honeyd.conf /etc/honeypot/honeyd.conf
COPY start_honeyd.sh /start_honeyd.sh
RUN dos2unix /etc/honeypot/honeyd.conf /start_honeyd.sh && chmod +x /start_honeyd.sh

WORKDIR /
ENTRYPOINT ["/bin/bash", "/start_honeyd.sh"]