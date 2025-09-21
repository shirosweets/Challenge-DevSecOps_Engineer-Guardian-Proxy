#!/bin/bash

echo "🔍 Estado actual de la app:"

echo "→ /admin sin header:"
curl -s -o /dev/null -w "Status: %{http_code}\n" http://localhost:8080/admin

echo "→ /admin con header:"
curl -s -H "X-Secret-Access: nginx-guardian" -o /dev/null -w "Status: %{http_code}\n" http://localhost:8080/admin

echo "→ Login usuario inexistente:"
curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"fake","password":"123"}' -o /dev/null -w "Status: %{http_code}\n"

echo "→ Login contraseña incorrecta:"
curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"user1","password":"wrong"}' -o /dev/null -w "Status: %{http_code}\n"

echo "→ Headers de seguridad:"
curl -s -I http://localhost:8080 | grep -E "(X-Frame-Options|X-Content-Type-Options|Strict-Transport-Security|Content-Security-Policy)"

echo "→ Server header:"
curl -s -I http://localhost:8080 | grep "Server:"