FROM ubuntu:focal
RUN apt-get update && apt-get install -y \
    nmap \
    iproute2 \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root
COPY scan.sh scan.sh
RUN chmod +x scan.sh

# ENTRYPOINT ["/bin/bash", "./scan.sh"]