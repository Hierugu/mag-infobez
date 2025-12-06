FROM ubuntu:focal
RUN apt-get update && apt-get install -y \
    nmap \
    iproute2 \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY scan_script.sh scan_script.sh
RUN chmod +x scan_script.sh
