#!/usr/bin/env bash
set -e

# Проверка на наличие .env
if [ ! -f ".env" ]; then
    echo "❌ Файл .env не найден! Скопируйте .env.example и заполните свои значения:"
    echo "cp .env.example .env"
    exit 1
fi

# Загружаем переменные из .env
source .env

echo "🚀 Установка Nextcloud All-in-One..."
echo "ℹ️  Админ: $NEXTCLOUD_ADMIN_USER, Домен/IP: $NEXTCLOUD_TRUSTED_DOMAINS"

# Устанавливаем Docker, если не установлен
if ! command -v docker &> /dev/null; then
    echo "📦 Устанавливаю Docker..."
    curl -fsSL https://get.docker.com | sh
fi

# Запускаем Nextcloud AIO
docker run   --sig-proxy=false   --name nextcloud-aio-mastercontainer   --restart always   -p 80:80 -p 8080:8080 -p 8443:8443   -e NEXTCLOUD_ADMIN_USER="$NEXTCLOUD_ADMIN_USER"   -e NEXTCLOUD_ADMIN_PASSWORD="$NEXTCLOUD_ADMIN_PASSWORD"   -e NEXTCLOUD_TRUSTED_DOMAINS="$NEXTCLOUD_TRUSTED_DOMAINS"   -e PHP_MEMORY_LIMIT="$PHP_MEMORY_LIMIT"   -e UPLOAD_MAX_SIZE="$UPLOAD_MAX_SIZE"   -v nextcloud_aio_mastercontainer:/mnt/docker-aio-config   -v /var/run/docker.sock:/var/run/docker.sock:ro   ghcr.io/nextcloud-releases/all-in-one:latest

echo "✅ Nextcloud запущен!"
echo "🌐 Открой в браузере: https://$NEXTCLOUD_TRUSTED_DOMAINS:8443"
echo "⚠️ Если сертификат не доверенный — просто подтверди исключение (для локальной сети это нормально)."

echo ""
echo "💖 Поддержать разработчика (USDT TRC20)"
echo "Адрес: TDb2rmYkYGoX2o322JmPR12oAUJbkgtaWg"
echo "QR-код сохранён в файле donate_qr.jpeg"

# Попробовать открыть QR-код автоматически
if command -v xdg-open &> /dev/null; then
    xdg-open donate_qr.jpeg
elif command -v open &> /dev/null; then
    open donate_qr.jpeg
fi
