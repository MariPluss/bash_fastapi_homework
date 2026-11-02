
#!/bin/bash

# Домашнее задание: автоматическое создание FastAPI-проекта

set -e

PROJECT_DIR="fastapi_project"

# Сообщение об ошибке
trap 'echo "Ошибка: выполнение скрипта прервано на строке $LINENO"' ERR

echo "=== Настройка FastAPI ==="

# 1. Проверка Python 3
if ! command -v python3 >/dev/null 2>&1; then
    echo "Ошибка: Python 3 не установлен."
    exit 1
fi

echo "Python 3 найден:"
python3 --version

# 2. Проверка pip
if ! python3 -m pip --version >/dev/null 2>&1; then
    echo "Ошибка: pip не установлен."
    exit 1
fi

echo "pip найден."

# 3. Проверка существования проекта
if [ -d "$PROJECT_DIR" ]; then
    echo "Папка $PROJECT_DIR уже существует."
    echo "Существующие файлы не будут перезаписаны."
    exit 1
fi

# 4. Создание папки проекта
echo "Создаём папку проекта..."
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# 5. Создание виртуального окружения
echo "Создаём виртуальное окружение..."
python3 -m venv venv

# 6. Активация виртуального окружения
source venv/bin/activate

# 7. Создание requirements.txt
echo "Создаём requirements.txt..."

cat > requirements.txt <<'EOF'
fastapi
uvicorn
pydantic
EOF

# 8. Установка зависимостей
echo "Устанавливаем зависимости..."
python -m pip install -r requirements.txt

# 9. Создание папок
echo "Создаём папки static и logs..."
mkdir -p static logs

# 10. Создание приложения FastAPI
echo "Создаём main.py..."

cat > main.py <<'EOF'
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"message": "Hello, FastAPI!"}
EOF

# 11. Запуск сервера
echo "=== Проект успешно создан! ==="
echo "Откройте http://127.0.0.1:8000/"
echo "Для остановки сервера нажмите Ctrl+C."

python -m uvicorn main:app --host 127.0.0.1 --port 8000
