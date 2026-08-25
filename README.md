# Модуль 9 — Управление релизами и зависимостями в Helm

В данном репозитории представлена финальная структура чарта `podinfo` с поддержкой динамических зависимостей, хуков миграции и разделением на DEV и PROD окружения.

## Структура проекта
* `charts/podinfo/` — исходный код родительского чарта.
* `releases/dev/podinfo.yaml` — конфигурация DEV-окружения (база данных PostgreSQL включена).
* `releases/prod/podinfo.yaml` — конфигурация PROD-окружения (база данных PostgreSQL отключена по фичефлагу).
* `docs/` — локальный репозиторий чартов, содержащий упакованный архив `.tgz` и `index.yaml`.

## Архитектурные особенности чарта
1. **Helm Hooks:** Добавлен pre-upgrade/pre-install Job миграции базы данных (`migrate-job.yaml`), блокирующий обновление основного приложения до успешного завершения скрипта.
2. **Subcharts (Управление зависимостями):** В чарт встроена зависимость от `postgresql` с использованием управляющего флага `condition: postgresql.enabled`.
3. **Шаблонизация условий (if/end):** Манифест `deployment.yaml` обёрнут в логические блоки. Переменные окружения и запросы к секретам базы данных генерируются **только** при условии `postgresql.enabled: true`, что предотвращает падение пода (`Error: secret not found`) на окружениях без БД.

## Инструкция по управлению релизами

### 1. Установка / Обновление окружений
Развертывание DEV-среды (с базой данных):
```bash
helm upgrade --install podinfo ~/helm-course/charts/podinfo -n podinfo-dev --create-namespace -f ~/helm-course/releases/dev/podinfo.yaml
```

Развертывание PROD-среды (без базы данных, синий цвет интерфейса):
```bash
helm upgrade --install podinfo-prod ~/helm-course/charts/podinfo -n podinfo-prod --create-namespace -f ~/helm-course/releases/prod/podinfo.yaml
```

### 2. Просмотр изменений перед деплоем (Плагин helm-diff)
```bash
helm diff upgrade podinfo-prod ~/helm-course/charts/podinfo -n podinfo-prod -f ~/helm-course/releases/prod/podinfo.yaml --set replicaCount=5
```

### 3. Откат релиза (Rollback)
В случае сбоя откат на стабильную Ревизию №1 выполняется командой:
```bash
helm rollback podinfo-prod 1 -n podinfo-prod
```

