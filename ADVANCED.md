# 🚀 MODO AVANZADO: JWT + NGINX + LUA VS AUTH0

## Objetivo
Extiende el challenge para que Nginx valide tokens JWT usando Lua, y compara esta solución con Auth0.

## Pasos
1. Modifica la app para que emita un JWT real (usa `jsonwebtoken` package).
2. Configura Nginx con módulo Lua para validar el JWT en el header `Authorization: Bearer <token>`.
3. Si el token es inválido o expirado, Nginx debe rechazar la request (401).
4. Solo permitir acceso a `/admin` si el JWT tiene `role: "admin"`.

## 📜 Pregunta Técnica Profunda

<!-- Deberias revisar bien algunos comentarios! :) -->

> **¿Por qué elegirías implementar autenticación JWT + validación en Nginx con Lua en lugar de usar Auth0? ¿Qué ventajas y desventajas tiene cada enfoque en términos de:**
> - Costo
> - Control
> - Escalabilidad
> - Complejidad operativa
> - Cumplimiento (ISO, PCI DSS, GDPR, SOC2, etc.)?
>
> **Da un ejemplo de escenario donde uno es claramente mejor que el otro.**

## 🧰 Recursos
- https://github.com/openresty/lua-nginx-module
- https://github.com/SkyLothar/lua-resty-jwt
- Ejemplo de validación JWT en Nginx + Lua:
  ```lua
  local jwt = require("resty.jwt")
  local claim = jwt:verify("your-secret", ngx.req.get_headers()["Authorization"]:sub(7))
  if not claim or not claim.valid then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
  end
  ```

<!-- “Los verdaderos guardianes dejan rastros que solo los dignos pueden ver.” - VSV -->