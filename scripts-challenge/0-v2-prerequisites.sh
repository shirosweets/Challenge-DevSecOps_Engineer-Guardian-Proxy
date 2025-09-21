#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

success() { echo -e "${GREEN}✅ $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

echo -e "${YELLOW}🔍 VERIFICANDO REQUISITOS DEL SISTEMA...${NC}"
echo "========================================"

ALL_OK=true

# Docker
echo -e "${YELLOW}1. Verificando Docker...${NC}"
if ! command -v docker &> /dev/null; then
    error "Docker no está instalado"
    ALL_OK=false
else
    DOCKER_VERSION=$(docker --version | grep -o '[0-9]\+' | head -n 1)
    if [ -z "$DOCKER_VERSION" ] || [ "$DOCKER_VERSION" -lt 28 ]; then
        error "Docker versión $DOCKER_VERSION (requiere >= 28)"
        ALL_OK=false
    else
        success "Docker $DOCKER_VERSION (>= 28)"
    fi
fi

# Docker Compose v2
echo -e "${YELLOW}2. Verificando Docker Compose v2...${NC}"
if docker compose version &> /dev/null; then
    success "Docker Compose v2 disponible"
else
    if command -v docker-compose &> /dev/null; then
        warning "Usas docker-compose (v1). Necesitas docker compose (v2)"
        ALL_OK=false
    else
        error "Docker Compose v2 no instalado"
        ALL_OK=false
    fi
fi

# jq
echo -e "${YELLOW}3. Verificando jq...${NC}"
if ! command -v jq &> /dev/null; then
    error "jq no está instalado"
    ALL_OK=false
else
    success "jq instalado"
fi

echo ""
[ "$ALL_OK" = true ] && echo -e "${GREEN}🎉 ¡TODOS LOS REQUISITOS CUMPLIDOS!${NC}" || echo -e "${RED}🚨 ALGUNOS REQUISITOS FALLARON.${NC}"