#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() { echo -e "${GREEN}✅ $1 (+$2 pts)${NC}"; PUNTOS=$((PUNTOS + $2)); }
error() { echo -e "${RED}❌ $1${NC}"; }

echo -e "${YELLOW}🛡️  EVALUANDO TU SOLUCIÓN...${NC}"
echo "No te decimos cómo arreglarlo. Solo si pasaste o no."
echo "=============================================="

PUNTOS=0

# 1. /admin con header
if curl -s -H "X-Secret-Access: nginx-guardian" http://localhost:8080/admin >/dev/null 2>&1; then
    success "Acceso autorizado a /admin con credenciales" 10
else
    error "No se puede acceder a /admin incluso con credenciales válidas"
fi

# 2. /admin sin header
if [ "$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/admin)" = "403" ]; then
    success "Acceso a /admin bloqueado sin credenciales" 10
else
    error "Acceso a /admin no está restringido adecuadamente"
fi

# 3. Login enumeration
R1=$(curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"usuario_inventado_xyz","password":"123"}' -w "%{http_code}" -o /dev/null)
R2=$(curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"user1","password":"contraseña_mala"}' -w "%{http_code}" -o /dev/null)

if [ "$R1" = "200" ] && [ "$R2" = "200" ]; then
    error "Login devuelve 200 en errores — ¡esto expone información sensible!"
elif [ "$R1" = "$R2" ]; then
    success "Respuestas de login indistinguibles para atacante" 20
else
    error "Las respuestas de login son distinguibles — ¡esto permite enumeración de usuarios!"
fi

# 4. Headers de seguridad
H=$(curl -s -I http://localhost:8080)
MISSING=0
for HDR in "X-Frame-Options" "X-Content-Type-Options" "Strict-Transport-Security" "Content-Security-Policy"; do
    if ! echo "$H" | grep -i "$HDR" >/dev/null; then
        MISSING=1
    fi
done
[ $MISSING -eq 0 ] && success "Políticas de seguridad del navegador aplicadas" 15 || error "Faltan políticas de seguridad críticas"

# 5. Rate limiting
S1=$(curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"user1","password":"wrong"}' -w "%{http_code}" -o /dev/null)
sleep 0.5
S2=$(curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"user1","password":"wrong"}' -w "%{http_code}" -o /dev/null)
sleep 0.5
S3=$(curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"user1","password":"wrong"}' -w "%{http_code}" -o /dev/null)
if [ "$S1" != "$S2" ] || [ "$S2" != "$S3" ]; then
    success "Mecanismo de protección contra fuerza bruta activo" 15
else
    error "No hay protección contra intentos de acceso masivos"
fi

# 6. Ocultar tecnología
H=$(curl -s -I http://localhost:8080)
if echo "$H" | grep -i "Server:" | grep -i -v "Express" >/dev/null && ! echo "$H" | grep -i "X-Powered-By" >/dev/null; then
    success "Tecnologías del backend correctamente ofuscadas" 10
else
    error "La pila tecnológica del backend está expuesta"
fi

# 7. Protección contra inyecciones
SQLI=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:8080/search?query='%20OR%201=1--")
if [ "$SQLI" = "403" ] || [ "$SQLI" = "400" ] || [ "$SQLI" = "401" ]; then
    success "Protección contra ataques de inyección detectada" 10
elif [ "$SQLI" = "200" ]; then
    error "El sistema es vulnerable a ataques de inyección"
else
    error "No se pudo determinar estado de protección contra inyecciones"
fi

# 8. Funcionalidad base — ¡NO SUMA, SOLO RESTA!
if curl -s -X POST http://localhost:8080/login -H "Content-Type: application/json" -d '{"username":"user1","password":"123456"}' | grep -q "token"; then
    echo -e "${GREEN}✅ Funcionalidad de login preservada${NC}"
else
    error "La aplicación ya no permite logins legítimos"
    PUNTOS=$((PUNTOS - 10))
fi

if curl -s "http://localhost:8080/search?query=test" >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Funcionalidad de búsqueda preservada${NC}"
else
    error "La aplicación ya no responde en endpoints críticos"
    PUNTOS=$((PUNTOS - 10))
fi

echo ""
echo -e "${GREEN}🎯 PUNTUACIÓN FINAL: $PUNTOS/100${NC}"

if [ $PUNTOS -ge 90 ]; then
    echo -e "${GREEN}🏆 ¡EXCELENTE! Tu solución es sólida y profesional.${NC}"
elif [ $PUNTOS -ge 70 ]; then
    echo -e "${YELLOW}👍 ¡BUEN TRABAJO! Con algunos ajustes, será imbatible.${NC}"
else
    echo -e "${RED}💪 ¡NO TE RINDAS! La seguridad se construye iteración tras iteración.${NC}"
fi

echo -e "${YELLOW}💡 Consejo del Guardián: No eres guardián de código… eres guardián de personas que confían en lo que construyes.${NC}"