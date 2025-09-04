const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 8080;

app.use(cors());
app.use(express.json());

// Mock de usuários
const users = [
  {
    id: '1',
    name: 'João Silva',
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
    name: 'Sindico Adailton',
    email: 'sindico@test.com',
    cpf: '56346475364',
    created_at: '2024-01-05T10:30:00Z',
    updated_at: '2025-09-04T15:45:00Z',
    is_active: true,
    role: 'manager'
  },
];

// Mock de senhas (em produção, use hash!)
const credentials = {
  'joao@test.com': '123456',
  'maria@test.com': '123456',
  'admin@test.com': '123456'
};

// Login endpoint
app.post('/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  console.log(`Login attempt: ${email}`);
  
  // Validar credenciais
  if (!credentials[email] || credentials[email] !== password) {
    return res.status(401).json({
      message: 'Credenciais inválidas'
    });
  }
  
  // Encontrar usuário
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
      token: `mock_token_${Date.now()}`,
      refresh_token: `mock_refresh_${Date.now()}`,
      user: user,
      expires_at: expiresAt.toISOString()
    });
  }, 1000); // 1 segundo de delay
});

// Logout endpoint
app.post('/auth/logout', (req, res) => {
  const authHeader = req.headers.authorization;
  console.log(`Logout request with token: ${authHeader}`);
  
  res.json({ message: 'Logout realizado com sucesso' });
});

// Refresh token endpoint
app.post('/auth/refresh', (req, res) => {
  const { refresh_token } = req.body;
  
  console.log(`Refresh token: ${refresh_token}`);
  
  // Simular token expirado às vezes
  if (Math.random() > 0.8) {
    return res.status(401).json({
      message: 'Refresh token expirado'
    });
  }
  
  const user = users[0]; // Retornar primeiro usuário por simplicidade
  const expiresAt = new Date();
  expiresAt.setHours(expiresAt.getHours() + 1);
  
  res.json({
    token: `new_token_${Date.now()}`,
    refresh_token: `new_refresh_${Date.now()}`,
    user: user,
    expires_at: expiresAt.toISOString()
  });
});

// Health check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    users_count: users.length
  });
});

// Listar usuários (para debug)
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