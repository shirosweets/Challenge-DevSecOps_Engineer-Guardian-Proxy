# 🔐 CHALLENGE: “El Proxy Guardián — Salvando una App Maldita con Nginx”

**“La seguridad no se copia. Se construye con curiosidad, ingenio y ética.”** - Valentina S. Vispo.

## 🎯 Objetivo

Recibes una app Node.js insegura. Debes protegerla usando **Nginx como proxy inverso**, aplicando configuraciónes de seguridad *sin modificar el código de la app*, pero realizando recomendaciones para cambios.

## 🛡️ Tu misión

1. Levantar la aplicacion y realizar recomendaciones de seguridad al equipo que la desarrollo desde dos escenarios:
   1. De manera como usuario (pensando como atancante, sin acceso al codigo) - recomendamos no ver los archivos en `app/` para mejor analisis
   2. Como auditor de seguridad: con acceso al codigo. Es importante NO modificar el codigo para este desafio!
2. Configura Nginx para:
   - Añadir headers de seguridad.
   - Ocultar headers del backend.
   - Limitar intentos de login.
   - Bloquear acceso a `/admin` a menos que se envíe `X-Secret-Access: nginx-guardian`.
   - Reescribir respuestas de login para no filtrar información.
   - Cualquier otra configuración seguridad o buena práctica que veas necesaria.
    > Esta configuración debe quedar en `nginx/`

    > “Tu misión no es solo hacer que funcione, es hacer que sea seguro.
    > Usa Nginx como tu escudo. Cada vulnerabilidad es una oportunidad para demostrar tu ingenio.
    > Y recuerda: las mejores defensas están en los detalles que otros ignoran.”

3. Prueba tus defensas con `scripts/test-attack.sh`.

4. Responde las preguntas técnicas al final. 🕵️‍♂️ <!-- El endpoint /admin solo debe ser accesible si el header X-Secret-Access: nginx-guardian está presente -->

> 🎁 Si entendiste el espíritu del challenge, incluye en tu entrega:
> *“Nginx no es solo un proxy, es un centinela.”*

### 🐳 Bonus **opcionales**

- Logs Estructurados en JSON (para monitoreo) - No de aplicacion, sino de Nginx.
- Bloquear escaneos automaticos.

## 📜 Reglas

Lee atentamente las reglas en [RULES.md](RULES.md) antes de comenzar.

## Herramientas y/o prerequisitos

- Git
- Docker >= v28
- Docker compose >= v2 (`docker compose` no `docker-compose`)
- Nginx
- jq
- Scripts brindados para corrobrar el desafio:
  - `scripts-challenge/0-check-prerequisites.sh`
  - `scripts-challenge/debug-app.sh`
  - `scripts-challenge/debug-setup.sh`
  - `scripts-challenge/test-attack.sh`

### Desafio avanzado

- JWT usando Lua

## Pasos para empezar

1. Clonar el repositorio en un la maquina virtual de Lubuntu
2. Instalar Docker, Docker Compose y jq
3. Corroborar los prerequisitos con
  ```bash
  chmod +x scripts-challenge/0-check-prerequisites.sh
  ./cripts-challenge/0-check-prerequisites.sh
  ```
  Y si todo esta correcto obtendremos:
  ```bash
  🔍 VERIFICANDO REQUISITOS DEL SISTEMA...
  ========================================
  1. Verificando Docker...
  ✅ Docker 28 instalado (>= 28)
  2. Verificando Docker Compose v2...
  ✅ Docker Compose v2 (2.39.4) instalado correctamente
  3. Verificando jq...
  ✅ jq (jq-1.8.1) instalado

  🎉 ¡TODOS LOS REQUISITOS CUMPLIDOS!
  Puedes proceder a levantar el entorno con: docker compose up --build
  ```
4. Iniciamos el proyecto
  ```bash
  docker compose up --build
  ```
5. Para chequear que la app esta ok:
  ```bash
  curl http://localhost:8080/health
  ```
  ```bash
  {"status":"OK","server":"Node.js EvilApp v1.0"}
  ```
6. Para corrobrar el estado de las resoluciones del challenge tenemos lo siguiente:
  ```bash

  ```
7. Ejecuta estos comandos para entender la app vulnerable:

  1. Login correcto
  ```bash
  curl -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","password":"123456"}'
  ```

  Output esperado:
  ```json
  {
    "message":"Login successful",
    "role":"admin",
    "token":"fake-jwt-token-for-demo"
  }
  ```

  2. Login con usuario inexistente
  ```bash
  curl -X POST http://localhost:8080/login \
    -H "Content-Type: application/json" \
    -d '{"username":"fake","password":"123"}'
  ```

  Output esperado:
  ```json
  {"error":"User not found"}
  ```

  3. Login con contraseña incorrecta
  ```bash
  curl -X POST http://localhost:8080/login \
    -H "Content-Type: application/json" \
    -d '{"username":"user1","password":"wrong"}'
  ```

  Output esperado:
  ```json
  curl -X POST http://localhost:8080/login \
    -H "Content-Type: application/json" \
    -d '{"username":"user1","password":"wrong"}'
  ```

  4. Acceso a /admin sin header
  ```bash
  curl -I http://localhost:8080/admin
  ```

  Output esperado:
  ```bash
  HTTP/1.1 403 Forbidden
  Server: nginx/1.29.1
  Date: Sat, 20 Sep 2025 23:55:55 GMT
  Content-Type: text/html
  Content-Length: 153
  Connection: keep-alive
  X-Content-Type-Options: nosniff
  ```

  5. Acceso a /admin con header
  ```bash
  curl -H "X-Secret-Access: nginx-guardian" http://localhost:8080/admin
  ```

  Output esperado:
  ```bash
  curl -H "X-Secret-Access: nginx-guardian" http://localhost:8080/admin
  ```

  6. Búsqueda (simula SQLi)
  ```bash
  curl "http://localhost:8080/search?query=laptop"
  ```

  Output esperado:
  ```json
  [{"id":1,"name":"Laptop","price":999}]
  ```

  ```bash
  curl "http://localhost:8080/search?query='%20OR%201=1--"
  ```

  Output esperado:
  ```json
  []
  ```

## Entrega

- Subir el proyecto a un repositorio privado en GitHub con tu solución.
- **README.md** con:
  - Instrucciones para replicar.
  - Inconvenientes o errores presentados.
  - Capturas o logs que demuestren que tus defensas funcionan, deben incluir fecha y hora.
  - (Opcional) Implementación del modo avanzado (ADVANCED.md).
- **RESPUESTAS.md**:
  - Respuestas a las preguntas técnicas.

Ejemplo de entrega esperada:

```bash
mi-solucion-proxy-guardian/
├── nginx/
│   └── nginx.conf          <-- ¡Su solución de hardening!
├── README.md               <-- Con documentación, capturas, y frase del guardián
└── evidence/               <-- (Opcional) Capturas de prueba
    ├── before-fix.png
    └── after-fix.png
```

## 🧠 Objetivo real del challenge: analisis critico

<!-- “Los guardianes ayudan a quienes demuestran curiosidad.” - V?S?V -->

No buscamos perfección técnica. Buscamos:

- **Curiosidad**: ¿Investigaste lo que no entendías?
- **Creatividad**: ¿Usaste enfoques originales?
- **Atención al detalle**: ¿Notaste lo que otros ignoran?
- **Ética**: ¿Resolviste el reto con tus propias manos y mente?

> 🛡️ “En DevSecOps, los héroes no son los que tienen las mejores herramientas, sino los que ven lo que otros pasan por alto.”

## 🧩 Consideraciones del desafio

- Uno de los usuarios se llama `adm1n`... pero tiene un carácter invisible. Usa `hexdump -C app/users.json` para verlo.
- El `server_name` en `nginx.conf` debe ser `secure.local` en modo dev.
<!-- - El header `X-Secret-Access` no está documentado en el código — solo en un comentario HTML aquí. -->
- Existen bonus opcionales como secretos. No restan puntos sino que suman. En caso de realizar los secretos, se debe incluir en tu entrega: “Soy Guardián de la Nube — no solo configuro, sino que protejo con ingenio.” al final de tu README.md

## 🚀 ¿Quieres un desafio mayor? Mira el archivo [ADVANCED.md](ADVANCED.md)

## Documentacion

https://nginx.org/en/docs/


## ❓ Preguntas Técnicas

1. ¿Cual fue el problema que presentaba el proyecto ser levantado?
2. ¿Por qué es peligroso que la app responda con mensajes distintos para “usuario no existe” vs “contraseña inválida”? ¿Cómo lo solucionaste desde Nginx?
3. ¿Qué es un proxy reverso? ¿Qué ejemplo se te ocurre que es bueno de implementar? ¿En qué casos no sería una buena implementación?
4. ¿Qué hace el header `Content-Security-Policy` y por qué es crítico?
5. ¿Cómo podrías mejorar el rate limiting para que sea más justo?
6. Si un atacante descubre el header `X-Secret-Access`, ¿qué otra capa de seguridad añadirías?
7. ¿Qué vulnerabilidades NO pueden ser mitigadas por Nginx?
8. ¿Por qué consideras que te solicitamos realizar el desafío en una máquina virtual?

<!-- ## 📊 Evaluación
Para ojos cursiosos...
- Headers de seguridad: 20 pts
- Mitigación de fuga de info: 15 pts
- Rate limiting: 10 pts
- Restricción /admin: 10 pts
- Superó trampas anti-IA: 20 pts
- Calidad de respuestas: 15 pts
- Cada bonus resuelto: 20 pts
- Documentación: 10 pts -->

---