FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    curl \
    iputils-ping \
    net-tools \
    iproute2 \
    ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

CMD ["/bin/bash", "-c", "tail -f /dev/null"]
