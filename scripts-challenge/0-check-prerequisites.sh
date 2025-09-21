#!/bin/bash

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔍 VERIFICANDO REQUISITOS DEL SISTEMA...${NC}"
echo "========================================"

# Función para imprimir resultados con color e icono
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

ALL_OK=true

# === 1. Verificar Docker instalado y versión >= 28 ===
echo -e "${YELLOW}1. Verificando Docker...${NC}"
if ! command -v docker &> /dev/null; then
    error "Docker no está instalado. Instálalo desde: https://docs.docker.com/engine/install/"
    ALL_OK=false
else
    DOCKER_VERSION=$(docker --version | grep -o '[0-9]\+' | head -n 1)
    if [ -z "$DOCKER_VERSION" ]; then
        error "No se pudo determinar la versión de Docker"
        ALL_OK=false
    elif [ "$DOCKER_VERSION" -lt 28 ]; then
        error "Versión de Docker ($DOCKER_VERSION) es menor a 28. Actualiza a Docker >= 28."
        ALL_OK=false
    else
        success "Docker $DOCKER_VERSION instalado (>= 28)"
    fi
fi

# === 2. Verificar Docker Compose v2 (plugin, no script) ===
echo -e "${YELLOW}2. Verificando Docker Compose v2...${NC}"
# Verificar si 'docker compose' funciona (plugin v2)
if docker compose version &> /dev/null; then
    COMPOSE_VERSION=$(docker compose version 2>/dev/null | grep -o '[0-9]\+.[0-9]\+.[0-9]\+' | head -n 1)
    if [ -n "$COMPOSE_VERSION" ]; then
        success "Docker Compose v2 ($COMPOSE_VERSION) instalado correctamente"
    else
        success "Docker Compose v2 está disponible"
    fi
else
    # Verificar si tiene el viejo 'docker-compose' (script v1)
    if command -v docker-compose &> /dev/null; then
        warning "Tienes docker-compose (v1), pero necesitas docker compose (v2)"
        echo -e "   ${YELLOW}Solución: Instala el plugin de Docker Compose v2:${NC}"
        echo -e "   curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose"
        echo -e "   chmod +x ~/.docker/cli-plugins/docker-compose"
        ALL_OK=false
    else
        error "Docker Compose v2 no está instalado. Sigue las instrucciones en:"
        echo -e "   https://docs.docker.com/compose/install/linux/#install-the-plugin-manually"
        ALL_OK=false
    fi
fi

# === 3. Verificar jq instalado ===
echo -e "${YELLOW}3. Verificando jq...${NC}"
if ! command -v jq &> /dev/null; then
    error "jq no está instalado. Instálalo con:"
    echo -e "   Ubuntu/Debian: sudo apt install jq"
    echo -e "   macOS: brew install jq"
    echo -e "   Fedora: sudo dnf install jq"
    ALL_OK=false
else
    JQ_VERSION=$(jq --version 2>/dev/null)
    success "jq ($JQ_VERSION) instalado"
fi

echo ""
if [ "$ALL_OK" = true ]; then
    echo -e "${GREEN}🎉 ¡TODOS LOS REQUISITOS CUMPLIDOS!${NC}"
    echo -e "${GREEN}Puedes proceder a levantar el entorno con: docker compose up --build${NC}"
else
    echo -e "${RED}🚨 ALGUNOS REQUISITOS FALLARON. Por favor, corrígelos antes de continuar.${NC}"
    exit 1
fi