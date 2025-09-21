#!/bin/bash
# Utilizar solo en caso de que sea necesario aplicar algun cambio en test-attack.sh por pruebas particulares

echo "🧹 Reparando test-attack.sh..."

cat > test-attack.sh << 'EOF'
#!/bin/bash

echo "Probando login enumeration..."
curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"nonexistent","password":"123"}' | jq 2>/dev/null || echo "{}"

echo ""
echo "Probando acceso a /admin sin header..."
curl -s -I http://localhost:8080/admin | head -n 1

echo ""
echo "Probando con header secreto..."
curl -s -H "X-Secret-Access: nginx-guardian" http://localhost:8080/admin | jq 2>/dev/null || echo "{}"

echo ""
echo "Probando SQLi pattern..."
curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"admin","password":"123\" OR 1=1--"}' -v 2>/dev/null

echo ""
echo "Simulando atacante con X-Forwarded-For..."
curl -s -H "X-Forwarded-For: 10.0.0.1" http://localhost:8080/login -o /dev/null
curl -s -H "X-Forwarded-For: 10.0.0.2" http://localhost:8080/login -o /dev/null

echo ""
echo "Probando rate limit (3 requests en 6 segundos)..."
for i in {1..3}; do
    STATUS=$(curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"user1","password":"wrong"}' -w "%{http_code}" -o /dev/null)
    echo "Intento $i: Status $STATUS"
    sleep 2
done
EOF

chmod +x test-attack.sh

echo "✅ Script reparado! :D"
echo "🚀 Ejecutando..."
./test-attack.sh