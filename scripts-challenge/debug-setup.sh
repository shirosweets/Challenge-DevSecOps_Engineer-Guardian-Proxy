#!/bin/bash

echo "🔍 1. Verificando estado de contenedores..."
docker compose ps

echo "🔍 2. Verificando logs de nginx..."
docker compose logs nginx | grep -i "emerg\|error\|fail"

echo "🔍 3. Verificando mapeo de puerto 8080..."
grep -n "8080:80" docker-compose.yml

echo "🔍 4. Verificando que nginx.conf no tiene error_page 200..."
grep -n "error_page 200" nginx/nginx.conf

echo "🧹 5. Reiniciando servicios..."
docker compose down
docker compose up --build