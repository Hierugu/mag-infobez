#!/bin/bash
set -e

echo "Настройка защиты атакуемой машины"

read -p "Шаг 9.a: Список текущих правил. Нажмите Enter для выполнения..."
iptables -L

read -p "Шаг 9.c: Форматированный список. Нажмите Enter для выполнения..."
iptables -S
echo "Правила сброшены."

read -p "Шаг 9.d: Сброс текущих правил. Нажмите Enter для выполнения..."
iptables -F
echo "Правила сброшены."

read -p "Шаг 9.e: Разрешить локальный интерфейс. Нажмите Enter для выполнения..."
iptables -A INPUT -i lo -j ACCEPT
echo "Loopback разрешён."

read -p "Шаг 9.f: Разрешить трафик на порт 22 и 80. Нажмите Enter для выполнения..."
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
echo "Порт HTTP разрешён."

read -p "Шаг 9.g: Удалить правило для SSH. Нажмите Enter для выполнения..."
iptables -D INPUT -p tcp -m tcp --dport 22 -j ACCEPT
echo "Порт SSH удален."

read -p "Шаг 9.h: Разрешить исходящие соединения. Нажмите Enter для выполнения..."
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
echo "Исходящие соединения разрешены."

read -p "Шаг 9.i: Установить политики по умолчанию (OUTPUT ACCEPT, INPUT DROP). Нажмите Enter для выполнения..."
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP
echo "Политики по умолчанию установлены."

read -p "Шаг 9.j: Просмотр списка правил. Нажмите Enter для выполнения..."
iptables -L

read -p "Шаг 9.k: Добавить правило для отброса NULL-пакетов. Нажмите Enter для выполнения..."
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
echo "NULL-пакеты будут отброшены."

read -p "Шаг 9.l: Добавить правило для отброса SYN-пакетов без состояние NEW. Нажмите Enter для выполнения..."
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
echo "Некорректные NEW-пакеты будут отброшены."

read -p "Шаг 9.m: Сброс XMAS пакетов. Нажмите Enter для выполнения..."
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
echo "XMAS-пакеты будут отброшены."

exit 0
