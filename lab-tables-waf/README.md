# Лабораторная работа: Iptables (часть 1)

## Цель
Ознакомиться с настройкой базовых правил `iptables` для защиты Linux-сервера и проверить их работоспособность при помощи сканирования `nmap` (XMAS‑scan).

## Требования
- 2 виртуальные машины с Linux
- Сетевые адаптеры обеих машин должны быть настроены в режиме NAT
- Учётные данные виртуальных машин: логин `user`, пароль `1234567` (если применимо)

## Роли
- Атакующая машина: X
- Атакуемая машина (сервер): N

## Перед началом
1. Запустите обе VM.
2. Зафиксируйте сетевые настройки (IP и MAC) на обеих машинах:

```sh
ip a
```

Запишите результаты в отчёт.

## Установка необходимых пакетов

На атакующей машине (X):

```sh
sudo apt-get update
sudo apt-get install -y curl
```

На атакуемой машине (N):

```sh
sudo apt-get update
sudo apt-get install -y apache2
sudo apt-get install -y libapache2-mod-security2
```

Проверьте загрузку модуля ModSecurity:

```sh
sudo apachectl -M | grep --color security2
```

Если вывод содержит `security2_module (shared)`, модуль загружен успешно.

## Сканирование (от атакующей машины)

Выполните XMAS-сканирование порта 80 на атакуемой машине и сохраните результат в отчёте:

```sh
sudo nmap -sX <IP_атакаемого> -p 80
```

## Настройка защиты `iptables` на атакуемой машине

1. Просмотрите текущие правила (таблица `filter`):

```sh
sudo iptables -L
sudo iptables -S
```

2. Сбросьте текущие правила (при необходимости):

```sh
sudo iptables -F
```

3. Разрешите локальный loopback-интерфейс:

```sh
sudo iptables -A INPUT -i lo -j ACCEPT
```

4. Разрешите входящие соединения на HTTP (порт 80):

```sh
sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
```

(в оригинальном задании временно разрешают SSH, затем удаляют правило — в этой работе SSH не используется)

5. Удалите правило для SSH, если оно было добавлено:

```sh
sudo iptables -D INPUT -p tcp -m tcp --dport 22 -j ACCEPT
```

6. Разрешите установленные входящие соединения (для корректной работы ответов на исходящие запросы):

```sh
sudo iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

7. Установите политики по умолчанию: разрешить выводящий трафик, блокировать входящий:

```sh
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P INPUT DROP
```

8. Просмотрите текущие правила:

```sh
sudo iptables -L -v
```

9. Добавьте правила для блокировки распространённых разведывательных/сканирующих пакетов:

```sh
# Блокировка NULL-пакетов
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Блокировка некорректных SYN-пакетов (NEW без SYN)
sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# Блокировка XMAS-пакетов
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
```

> Примечание: используйте двойной дефис `--` перед опциями (`--dport`, `--tcp-flags`, `--syn`).

## Сохранение правил

По умолчанию правила `iptables` действуют до следующей перезагрузки. Чтобы сохранить их между перезагрузками, установите `iptables-persistent`:

```sh
sudo apt-get install -y iptables-persistent
```

Во время установки вам будет предложено сохранить текущие правила — подтвердите, если они протестированы.

## Завершение и отчёт
1. С другой виртуальной машины выполните ещё одно XMAS-сканирование и зафиксируйте результат:

```sh
sudo nmap -sX <IP_атакаемого>
```

2. В отчёте укажите:
- IP и MAC обеих машин
- Выводы `ip a`
- Выполненные команды установки
- Результаты `nmap`-сканирований (до и после применения правил)
- Список и содержимое правил `iptables` (`sudo iptables -S`)

---

## Часть 2. WAF

### 11. Используем набор правил OWASP
Для более серьёзной защиты используйте набор правил OWASP CRS.

### 12. Установка CRS на атакуемую машину

```sh
cd ~
git clone https://github.com/coreruleset/coreruleset.git
cd coreruleset
sudo cp crs-setup.conf.example /etc/modsecurity/crs-setup.conf
sudo cp -R rules/ /etc/modsecurity/
```

Если в наборе есть несовместимое правило (см. дополнение), удалите его перед запуском Apache:

```sh
sudo rm /etc/modsecurity/rules/REQUEST-922-MULTIPART-ATTACK.conf
```

### 13–16. Настройка ModSecurity

Переименуйте рекомендуемый конфиг и включите режим блокировки:

```sh
sudo mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
# Откройте и измените SecRuleEngine DetectionOnly -> SecRuleEngine On
sudo nano /etc/modsecurity/modsecurity.conf
```

Убедитесь, что `security2.conf` подключает правила CRS (отредактируйте при необходимости):

```sh
sudo nano /etc/apache2/mods-enabled/security2.conf
sudo service apache2 reload
```

Логи ModSecurity сохраняются в:

```
/var/log/apache2/modsec_audit.log
```

### Тестирование WAF

18. Добавьте тестовое правило в `/etc/apache2/sites-available/000-default.conf` перед `</VirtualHost>`:

```apacheconf
SecRuleEngine On
SecRule ARGS:testparam "@contains test" "id:1234,deny,status:403,msg:'Our test rule has triggered'"
```

19. С атакующей машины выполните тест-запрос:

```sh
curl "http://<IP_атаемого>/index.html?testparam=test"
```

Ожидаемый результат: `403 Forbidden`.

20. Для дополнительной проверки выполните WAF-фингерпринтинг (наглядных результатов может не быть):

```sh
sudo nmap -p 80 -sV --script=http-waf-fingerprint <IP_атаемого>
```

21. Просмотрите лог `modsec_audit.log` для подтверждения записей:

```sh
sudo less /var/log/apache2/modsec_audit.log
```

## Часть 3. Самостоятельная работа

### Выбор проекта Firewall
Выберите один из проектов для развёртывания (примерные ссылки):

- **pfSense** — https://www.pfsense.org/download/
- **OPNsense** — https://opnsense.org/download/
- **IPFire** — https://www.ipfire.org/download
- **Shorewall** — https://shorewall.org/download.html
- **Собственное решение**

Требования к выбору:

- Развёртывание в локальной сети и защита нескольких узлов
- Накопление событий и логирование срабатываний
- Возможность написания собственных правил блокировки

### Пункты отчёта

1. Архитектура решения (виртуализация/контейнеризация, подсети, схема прохождения трафика)
2. Процесс установки выбранной системы
3. Настройка конфигурации и правил (в т.ч. для Honeypot)
4. Доступ к системе логирования/детектирования
5. Сканирование выбранной системы (Nmap и аналоги)
6. Пример изменения правил и расширения эмуляции сервисов
7. Повторное сканирование и анализ результатов

## Часть 4. Экспорт событий в SIEM

### Выбор SIEM-проекта
Выберите одну из платформ:

- **Wazuh** — https://wazuh.com/
- **Security Onion** — https://github.com/Security-Onion-Solutions/security-onion
- **Собственная система**

Задачи:

1. Добавить узел SIEM в архитектуру
2. Описать реализованную схему интеграции
3. Подготовить демонстрацию: сканирование из части 3 с отображением накопленных событий в SIEM
