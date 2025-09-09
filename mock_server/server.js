const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 8080;

app.use(cors());
app.use(express.json());

const users = [
  {
    id: '1',
    name: 'Porteiro João',
    email: 'joao@test.com',
    cpf: '12345678901',
    created_at: '2024-01-15T10:30:00Z',
    updated_at: '2025-09-04T15:45:00Z',
    is_active: true,
    role: 'doorman'
  },
  {
    id: '2',
    name: 'Maria Santos',
    email: 'maria@test.com',
    cpf: '98765432101',
    created_at: '2024-01-10T08:20:00Z',
    is_active: true,
    role: 'resident'
  },
  {
    id: '3',
    name: 'Sindico Admin',
    email: 'admin@test.com',
    cpf: '56346475364',
    created_at: '2024-01-05T10:30:00Z',
    updated_at: '2025-09-04T15:45:00Z',
    is_active: true,
    role: 'manager'
  },
];

const credentials = {
  'joao@test.com': '123456',
  'maria@test.com': '123456',
  'admin@test.com': '123456'
};

app.post('/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  console.log(`Login attempt: ${email}`);
  
  if (!credentials[email] || credentials[email] !== password) {
    return res.status(401).json({
      message: 'Credenciais inválidas'
    });
  }
  
  const user = users.find(u => u.email === email);
  if (!user) {
    return res.status(404).json({
      message: 'Usuário não encontrado'
    });
  }
  
  // Simular delay de rede
  setTimeout(() => {
    const expiresAt = new Date();
    expiresAt.setHours(expiresAt.getHours() + 1);
    
    res.json({
      token: `mock_token_${Date.now()}_${user.id}`,
      refresh_token: `mock_refresh_${Date.now()}_${user.id}`,
      user: user,
      expires_at: expiresAt.toISOString()
    });
  }, 1000); 
});

app.post('/auth/logout', (req, res) => {
  const authHeader = req.headers.authorization;
  console.log(`Logout request with token: ${authHeader}`);
  
  res.json({ message: 'Logout realizado com sucesso' });
});

app.post('/auth/refresh', (req, res) => {
  const { refresh_token } = req.body;
  
  console.log(`Refresh token: ${refresh_token}`);
  
  if (Math.random() > 0.8) {
    return res.status(401).json({
      message: 'Refresh token expirado'
    });
  }
  
  let user = users[0]; // fallback
  
  if (refresh_token && refresh_token.includes('mock_refresh_')) {
    const tokenParts = refresh_token.split('_');
    if (tokenParts.length >= 3) {
      const userId = tokenParts[tokenParts.length - 1];
      const foundUser = users.find(u => u.id === userId);
      if (foundUser) {
        user = foundUser;
      }
    }
  }
  
  const expiresAt = new Date();
  expiresAt.setHours(expiresAt.getHours() + 1);
  
  res.json({
    token: `new_token_${Date.now()}_${user.id}`,
    refresh_token: `new_refresh_${Date.now()}_${user.id}`,
    user: user,
    expires_at: expiresAt.toISOString()
  });
});

app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    users_count: users.length
  });
});

app.get('/users', (req, res) => {
  res.json({
    users: users,
    credentials: Object.keys(credentials)
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Mock server running on http://localhost:${PORT}`);
  console.log(`📋 Available endpoints:`);
  console.log(`   POST /auth/login`);
  console.log(`   POST /auth/logout`);
  console.log(`   POST /auth/refresh`);
  console.log(`   GET /health`);
  console.log(`   GET /users`);
  console.log(`\n🔑 Test credentials:`);
  Object.entries(credentials).forEach(([email, password]) => {
    console.log(`   ${email} : ${password}`);
  });
});