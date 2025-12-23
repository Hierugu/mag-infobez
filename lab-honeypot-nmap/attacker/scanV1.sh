#!/bin/bash
TARGET_IP="172.16.238.10"
AUTO_MODE=false

# Check for --auto argument
if [[ "$1" == "--auto" ]]; then
    AUTO_MODE=true
fi

# Функция для ожидания нажатия Enter
wait_for_user() {
    if [[ "$AUTO_MODE" == true ]]; then
        sleep 1
    else
        echo -e "\nНажмите ENTER для продолжения..."
        read
    fi
}

echo -e "\n=== TCP Connect Scan (-sT) ==="
wait_for_user
nmap -n -sT -v $TARGET_IP

echo -e "\n=== TCP SYN Scan (-sS) ==="
wait_for_user
nmap -n -sS -v $TARGET_IP

echo -e "\n=== FIN Scan (-sF) ==="
wait_for_user
nmap -n -sF -v $TARGET_IP

echo -e "\n=== Xmas Tree Scan (-sX) ==="
wait_for_user
nmap -n -sX -v $TARGET_IP

echo -e "\n=== NULL Scan (-sN) ==="
wait_for_user
nmap -n -sN -v $TARGET_IP

echo -e "\n=== ACK Scan (-sA) ==="
wait_for_user
nmap -n -sA -v $TARGET_IP

echo -e "\n=== TCP Window Scan (-sW) ==="
wait_for_user
nmap -n -sW -v $TARGET_IP

echo -e "\n=== IP Protocol Scan (-sO) ==="
wait_for_user
nmap -n -sO -v $TARGET_IP

echo -e "\n=== RPC Scan (-sR) ==="
wait_for_user
nmap -n -sR -v $TARGET_IP

echo -e "\n=== OS Detection Scan (-O) ==="
wait_for_user
nmap -n -O -v $TARGET_IP

echo -e "\n=== Aggressive Scan (-A -T4) ==="
wait_for_user
nmap -n -A -T4 -v $TARGET_IP

echo -e "\n=== UDP Scan (-sU --top-ports 20) ==="
wait_for_user
nmap -n -sU -v --top-ports 20 $TARGET_IP

echo -e "\n=== Combined Scan (SYN+Services+OS) ==="
wait_for_user
nmap -n -sS -sV -O -T4 -p 1-1000 $TARGET_IP

echo -e "\n=== Fragmented Packet Scan (-sS -f) ==="
wait_for_user
nmap -n -sS -f -v $TARGET_IP

echo -e "\n=== Spoofed MAC Scan (--spoof-mac 0) ==="
wait_for_user
nmap -n -sS -v --spoof-mac 0 $TARGET_IP

# echo -e "\n=== Slow Scan (-sS -T1) ==="
# wait_for_user
# nmap -sS -T1 -v $TARGET_IP

echo -e "\n=== All Ports SYN Scan (-p- --max-retries 1 -T4) ==="
wait_for_user
nmap -n -sS -p- --max-retries 1 -T4 $TARGET_IP

echo -e "\n=== Honeypot Detection Script Scan ==="
wait_for_user
nmap -n -sS --script=http-title,ssh-hostkey,ssl-cert -v $TARGET_IP

echo -e "\n=== Version Detection Scan (-sV) ==="
wait_for_user
nmap -n -sV -v $TARGET_IP

# echo -e "\n=== XML Output Scan (-sS -oX) ==="
# nmap -sS -oX $LOG_DIR/${TIMESTAMP}_nmap_scan.xml $TARGET_IP


# echo -e "${BLUE}=== Дополнительные сканирования ===${NC}"

# echo -e "\n=== Windows Specific Ports (-sS -p 135,139,445,3389) ==="
# nmap -sS -p 135,139,445,3389 -v $TARGET_IP

# echo -e "\n=== Port Range 1-1000 (-sS -p 1-1000) ==="
# nmap -sS -p 1-1000 -v $TARGET_IP

# echo -e "\n=== Standard Service Detection (-sS -sV --top-ports 50) ==="
# nmap -sS -sV --top-ports 50 -v $TARGET_IP