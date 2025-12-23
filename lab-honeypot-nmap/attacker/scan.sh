#!/bin/bash

# Конфигурация
TARGET_IP="172.16.238.10"
AUTO_MODE=false

# Парсинг аргументов
while [[ $# -gt 0 ]]; do
    case $1 in
        --auto)
            AUTO_MODE=true
            shift
            ;;
        -h|--help)
            echo "Использование: $0 [OPTIONS] [TARGET_IP]"
            echo ""
            echo "OPTIONS:"
            echo "  --auto              Автоматический режим (без ожидания Enter)"
            echo "  -h, --help          Показать эту справку"
            echo ""
            echo "ПРИМЕРЫ:"
            echo "  $0                           # Сканировать 172.16.238.10 в интерактивном режиме"
            echo "  $0 192.168.1.1              # Сканировать 192.168.1.1 в интерактивном режиме"
            echo "  $0 --auto 192.168.1.1       # Сканировать 192.168.1.1 в автоматическом режиме"
            exit 0
            ;;
        *)
            # Предполагаем, что это IP адрес
            TARGET_IP=$1
            shift
            ;;
    esac
done

# Функция для ожидания нажатия Enter или автоматической задержки
wait_for_user() {
    if [[ "$AUTO_MODE" == true ]]; then
        sleep 1
    else
        echo -e "\nНажмите ENTER для продолжения..."
        read
    fi
}

echo -e "\n╔════════════════════════════════════════════════════════════╗"
echo -e "║     СКАНИРОВАНИЕ HONEYPOT ЦЕЛЕВОГО ХОСТА                   ║"
echo -e "║     Target: $TARGET_IP                                     ║"
echo -e "╚════════════════════════════════════════════════════════════╝"

# 1. TCP Connect Scan (-sT)
echo -e "\n=== 1. TCP Connect Scan (-sT) ==="
echo "Метод: полное установление TCP-соединения"
wait_for_user
nmap -n -sT -v $TARGET_IP

# 2. TCP SYN Scan (-sS)
echo -e "\n=== 2. TCP SYN Scan (-sS) ==="
echo "Метод: полуоткрытое сканирование (посылается только SYN)"
wait_for_user
nmap -n -sS -v $TARGET_IP

# 3. FIN Scan (-sF)
echo -e "\n=== 3. FIN Scan (-sF) ==="
echo "Метод: передаются пакеты с флагом FIN"
wait_for_user
nmap -n -sF -v $TARGET_IP

# 4. Xmas Tree Scan (-sX)
echo -e "\n=== 4. Xmas Tree Scan (-sX) ==="
echo "Метод: пакет с флагами FIN, PSH, URG"
wait_for_user
nmap -n -sX -v $TARGET_IP

# 5. NULL Scan (-sN)
echo -e "\n=== 5. NULL Scan (-sN) ==="
echo "Метод: пакет без установленных флагов"
wait_for_user
nmap -n -sN -v $TARGET_IP

# 6. IP Protocol Scan (-sO)
echo -e "\n=== 6. IP Protocol Scan (-sO) ==="
echo "Метод: определение поддерживаемых IP-протоколов"
wait_for_user
nmap -n -sO -v $TARGET_IP

# 7. ACK Scan (-sA)
echo -e "\n=== 7. ACK Scan (-sA) ==="
echo "Метод: ACK-пакеты для анализа фильтрации"
wait_for_user
nmap -n -sA -v $TARGET_IP

# 8. TCP Window Scan (-sW)
echo -e "\n=== 8. TCP Window Scan (-sW) ==="
echo "Метод: анализ окна TCP"
wait_for_user
nmap -n -sW -v $TARGET_IP

# 9. RPC Scan (-sR)
echo -e "\n=== 9. RPC Scan (-sR) ==="
echo "Метод: определение RPC-служб"
wait_for_user
nmap -n -sR -v $TARGET_IP

# 10. OS Detection (-O)
echo -e "\n=== 10. OS Detection Scan (-O) ==="
echo "Метод: определение операционной системы"
wait_for_user
nmap -n -O -v $TARGET_IP

echo -e "\n╔════════════════════════════════════════════════════════════╗"
echo -e "║     СКАНИРОВАНИЕ ЗАВЕРШЕНО                                 ║"
echo -e "╚════════════════════════════════════════════════════════════╝\n"
