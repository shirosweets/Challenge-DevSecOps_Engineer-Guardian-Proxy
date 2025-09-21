# 1. Login correcto
curl -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","password":"123456"}'

# 2. Login con usuario inexistente (filtra existencia)
curl -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{"username":"fake","password":"123"}'

# 3. Login con contraseña incorrecta (filtra que el usuario existe)
curl -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","password":"wrong"}'

# 4. Acceso a /admin sin header (¡debería estar bloqueado!)
curl -I http://localhost:8080/admin

# 5. Acceso a /admin con header (¡debería funcionar!)
curl -H "X-Secret-Access: nginx-guardian" http://localhost:8080/admin

# 6. Búsqueda (simula SQLi)
curl "http://localhost:8080/search?query=laptop"
curl "http://localhost:8080/search?query='%20OR%201=1--"