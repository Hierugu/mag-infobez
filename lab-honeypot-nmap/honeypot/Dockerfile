FROM ubuntu:focal

# Установка зависимостей и компиляция Honeyd
RUN apt-get update && apt-get install -y \
    build-essential \
    libpcap-dev \
    libdumbnet-dev \
    libevent-dev \
    libreadline-dev \
    zlib1g-dev \
    autoconf \
    automake \
    libtool \
    wget \
    tar \
    farpd \
    iproute2 \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Установка Python для скриптов установки Honeyd
RUN apt-get update && apt-get install -y python3 \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# Компиляция и установка Honeyd
WORKDIR /tmp
RUN wget https://github.com/DataSoft/Honeyd/archive/refs/heads/master.tar.gz && tar xzf master.tar.gz

RUN cd Honeyd-master && \
    autoreconf -fi && \
    ./configure && \
    make && \
    (make install || true) && \
    mkdir -p /usr/share/honeyd && \
    cp -r scripts webserver xprobe2.conf /usr/share/honeyd/ || true && \
    cp nmap.prints /usr/share/honeyd/nmap-os-db || true && \
    touch /usr/share/honeyd/nmap.assoc && \
    honeyd --version && \
    cd / && \
    rm -rf /tmp/* && \
    apt-get purge -y build-essential autoconf automake libtool && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Настройка Honeyd
RUN mkdir -p /etc/honeypot /var/log
COPY honeyd.conf /etc/honeypot/honeyd.conf
COPY start_honeyd.sh /start_honeyd.sh
RUN chmod +x /start_honeyd.sh

WORKDIR /

CMD ["/start_honeyd.sh"]