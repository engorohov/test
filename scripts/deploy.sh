#!/bin/bash
echo "=== СТАРТ ТОТАЛЬНОГО ДЕПЛОЯ КЛАСТЕРА ==="

echo "🚀 Разворачиваем DEV-окружение (с базой данных)..."
helm upgrade --install podinfo my-podinfo/podinfo \
  -n podinfo-dev \
  --create-namespace \
  -f ~/helm-course/releases/dev/podinfo.yaml

echo "🚀 Разворачиваем PROD-окружение (чистый сайт, синий интерфейс)..."
helm upgrade --install podinfo-prod my-podinfo/podinfo \
  -n podinfo-prod \
  --create-namespace \
  -f ~/helm-course/releases/prod/podinfo.yaml

echo "=== ВСЕ ОКРУЖЕНИЯ УСПЕШНО ЗАПУЩЕНЫ! ==="

