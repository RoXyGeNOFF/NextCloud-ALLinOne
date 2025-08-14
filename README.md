#Nextcloud All-In-One (AIO).
Это официальный вариант, который сам поднимет всё (БД, Redis, Cron, Collabora/OnlyOffice, резервные копии).
Нужно будет только вписать свои параметры в маленький конфиг и запустить один скрипт.

Включает:
1.Cам Nextcloud,
2.Nextcloud Office,
3.Высокопроизводительный backend,
4.Резервное копирование (BorgBackup),
5.Поддержку вирусного сканирования (ClamAV), полнотекстовый поиск и многое другое.


ШАГ №1
Создаём конфиг

Сделаем файл nextcloud.env в домашней папке сервера:
bash:
nano ~/nextcloud.env

Впиши свои значения в nextcloud.env : 

# === ОБЯЗАТЕЛЬНО ЗАМЕНИТЕ ЭТИ ПОЛЯ ===
NEXTCLOUD_ADMIN_USER=admin            # Логин администратора Nextcloud
NEXTCLOUD_ADMIN_PASSWORD=ChangeMe123  # Пароль администратора
NEXTCLOUD_TRUSTED_DOMAINS=192.168.1.50 # IP или домен сервера

# === МОЖНО НЕ МЕНЯТЬ ===
UPLOAD_MAX_SIZE=10G
PHP_MEMORY_LIMIT=1024M

(NEXTCLOUD_TRUSTED_DOMAINS — если у тебя только локальная сеть, впиши IP сервера (например, 192.168.1.50).
Если хочешь доступ снаружи — впиши свой домен (cloud.mysite.com).
NEXTCLOUD_ADMIN_USER и NEXTCLOUD_ADMIN_PASSWORD — твой логин/пароль для входа. Сохраняем)

Скрипт установки:
Создаём скрипт install_nextcloud.sh
nano ~/install_nextcloud.sh
Вставляем:
#!/usr/bin/env bash
set -e

# Загружаем переменные
source ~/nextcloud.env

# Устанавливаем Docker (если ещё не установлен)
curl -fsSL https://get.docker.com | sh

# Запускаем Nextcloud All-in-One Mastercontainer
docker run \
  --sig-proxy=false \
  --name nextcloud-aio-mastercontainer \
  --restart always \
  -p 80:80 -p 8080:8080 -p 8443:8443 \
  -e NEXTCLOUD_ADMIN_USER="$NEXTCLOUD_ADMIN_USER" \
  -e NEXTCLOUD_ADMIN_PASSWORD="$NEXTCLOUD_ADMIN_PASSWORD" \
  -e NEXTCLOUD_TRUSTED_DOMAINS="$NEXTCLOUD_TRUSTED_DOMAINS" \
  -e PHP_MEMORY_LIMIT="$PHP_MEMORY_LIMIT" \
  -e UPLOAD_MAX_SIZE="$UPLOAD_MAX_SIZE" \
  -v nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  ghcr.io/nextcloud-releases/all-in-one:latest

Сохраняем

Делаем исполняемым:
chmod +x ~/install_nextcloud.sh

Запуск
Теперь всё делается одной командой:
~/install_nextcloud.sh

Скрипт:

1.Установит Docker (если нет).
2.Запустит контейнер Nextcloud AIO.
3.Передаст в него все твои настройки из nextcloud.env.

После запуска открой браузер:
https://<твой_IP_или_домен>:8443
Если браузер ругается на сертификат — просто подтверди (для локальной сети это нормально).
Войдёшь под NEXTCLOUD_ADMIN_USER и NEXTCLOUD_ADMIN_PASSWORD

Profit
