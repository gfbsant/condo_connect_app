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
    phone: '(11) 99999-1111',
    created_at: '2024-01-15T10:30:00Z',
    updated_at: '2025-09-04T15:45:00Z',
    is_active: true,
    role: 'doorman'
  },
  {
    id: '2',
    name: 'Maria Santos',
    email: 'maria@test.com',
    phone: '(11) 88888-2222',
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
    phone: '(11) 77777-3333',
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

function isValidCPF(cpf) {
  cpf = cpf.replace(/[^\d]/g, '');
  
  if (cpf.length !== 11 || /^(\d)\1*$/.test(cpf)) {
    return false;
  }
  
  let sum = 0;
  for (let i = 0; i < 9; i++) {
    sum += parseInt(cpf[i]) * (10 - i);
  }
  let firstDigit = 11 - (sum % 11);
  if (firstDigit >= 10) firstDigit = 0;
  
  if (parseInt(cpf[9]) !== firstDigit) return false;
  
  sum = 0;
  for (let i = 0; i < 10; i++) {
    sum += parseInt(cpf[i]) * (11 - i);
  }
  let secondDigit = 11 - (sum % 11);
  if (secondDigit >= 10) secondDigit = 0;
  
  return parseInt(cpf[10]) === secondDigit;
}

function isValidEmail(email) {
  const emailRegex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;
  return emailRegex.test(email);
}

function generateId() {
  return (users.length + 1).toString();
}

app.post('/auth/register', (req, res) => {
  const { name, email, password, cpf, phone } = req.body;
  
  console.log(`Register attempt: ${email}`);
  
  if (!name || !email || !password || !cpf) {
    return res.status(400).json({
      message: 'Nome, email, senha e CPF são obrigatórios'
    });
  }
  
  if (!isValidEmail(email)) {
    return res.status(400).json({
      message: 'Email inválido'
    });
  }
  
  if (!isValidCPF(cpf)) {
    return res.status(400).json({
      message: 'CPF inválido'
    });
  }
  
  if (password.length < 6) {
    return res.status(400).json({
      message: 'Senha deve ter pelo menos 6 caracteres'
    });
  }
  
  const existingUserByEmail = users.find(u => u.email.toLowerCase() === email.toLowerCase());
  if (existingUserByEmail) {
    return res.status(409).json({
      message: 'Email já cadastrado'
    });
  }
  
  const cleanCpf = cpf.replace(/[^\d]/g, '');
  const existingUserByCpf = users.find(u => u.cpf.replace(/[^\d]/g, '') === cleanCpf);
  if (existingUserByCpf) {
    return res.status(409).json({
      message: 'CPF já cadastrado'
    });
  }
  
  setTimeout(() => {
    const newUser = {
      id: generateId(),
      name: name.trim(),
      email: email.toLowerCase().trim(),
      cpf: cleanCpf,
      phone: phone ? phone.trim() : null,
      role: 'resident', 
      status: 'active',
      created_at: new Date().toISOString(),
      updated_at: null,
    };
    
    users.push(newUser);
    
    credentials[newUser.email] = password;
    
    console.log(`✅ User registered successfully: ${newUser.email}`);
    
    res.status(201).json({
      message: 'Usuário cadastrado com sucesso',
      user: newUser
    });
  }, 1500); 
});

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

app.get('/debug/users-credentials', (req, res) => {
  res.json({
    users_with_credentials: users.map(user => ({
      ...user,
      password: credentials[user.email] || 'N/A'
    }))
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Mock server running on http://localhost:${PORT}`);
  console.log(`📋 Available endpoints:`);
  console.log(`   POST /auth/login`);
  console.log(`   POST /auth/register`); 
  console.log(`   POST /auth/logout`);
  console.log(`   POST /auth/refresh`);
  console.log(`   GET /health`);
  console.log(`   GET /users`);
  console.log(`   GET /debug/users-credentials`);
  console.log(`\n🔑 Test credentials:`);
  Object.entries(credentials).forEach(([email, password]) => {
    console.log(`   ${email} : ${password}`);
  });
  console.log(`\n📝 To test registration, send POST to /auth/register with:`);
  console.log(`   { "name": "Test User", "email": "test@example.com", "password": "12345678", "cpf": "12345678901", "phone": "(11) 99999-9999" }`);
});