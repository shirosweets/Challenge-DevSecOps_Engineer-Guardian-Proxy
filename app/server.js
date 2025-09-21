const express = require('express');
const fs = require('fs');
const app = express();

app.use(express.json());

const users = JSON.parse(fs.readFileSync('./users.json', 'utf8'));

const products = [
  { id: 1, name: "Laptop", price: 999 },
  { id: 2, name: "Mouse", price: 25 },
  { id: 3, name: "Keyboard", price: 75 },
  { id: 4, name: "Monitor", price: 199 }
];

// No aplicar rate limit a este endpoint
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  const user = users.find(u => u.username === username);

  if (!user) {
    return res.status(200).json({ error: "User not found" });
  }

  if (user.password !== password) {
    return res.status(200).json({ error: "Invalid password" });
  }

  res.json({
    message: "Login successful",
    role: user.role,
    token: "fake-jwt-token-for-demo"
  });
});

// Endpoint al que vamos a implementar el rate limit
app.post('/login-rate-limit', (req, res) => {
  const { username, password } = req.body;

  const user = users.find(u => u.username === username);

  if (!user) {
    return res.status(200).json({ error: "User not found" });
  }

  if (user.password !== password) {
    return res.status(200).json({ error: "Invalid password" });
  }

  res.json({
    message: "Login successful",
    role: user.role,
    token: "fake-jwt-token-for-demo"
  });
});

app.get('/admin', (req, res) => {
  res.json({ secret: "SuperAdminPanel - No auth required!" });
});

app.get('/health', (req, res) => res.json({ status: "OK", server: "Node.js EvilApp v1.0" }));

// ¿Qué problemas tiene esta implementación?
// app.get('/search', (req, res) => {
//   const query = req.query.query;
//   const sql = `SELECT * FROM products WHERE name LIKE '%${query}%'`;
//   db.query(sql, (err, results) => {
//     if (err) return res.status(500).json({ error: "Database error" });
//     res.json(results);
//   });
// });

app.get('/search', (req, res) => {
  const query = req.query.query || "";
  const results = products.filter(p =>
    p.name.toLowerCase().includes(query.toLowerCase())
  );
  res.json(results);
});

app.get('/user/:id', (req, res) => {
  const id = req.params.id;
  const user = users.find(u => u.id == id);
  if (!user) return res.status(404).json({ error: "User not found" });
  res.json(user);
});

app.post('/update-profile', (req, res) => {
  const { id, ...updates } = req.body;
  const user = users.find(u => u.id == id);
  if (!user) return res.status(404).json({ error: "User not found" });
  Object.assign(user, updates);
  res.json({ message: "Profile updated", user });
});

app.listen(3000, () => console.log('App corriendo en http://localhost:3000'));