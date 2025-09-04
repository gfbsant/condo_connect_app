# Condo Connect

## Mapeamento de Histórias de Usuário

### Autenticação

#### HU001 - Cadastrar Usuário
- **View:** `views/auth/register_view.dart`
- **ViewModel:** `auth_viewmodel.dart`
- **Service:** `auth_service.dart`
- **Model:** `user_model.dart`
- **Utils:** `core/utils/validators.dart`

*Validação de email, CPF e senha antes do envio à API*

#### HU002 - Autenticar Usuário
- **View:** `views/auth/login_view.dart`
- **ViewModel:** `auth_viewmodel.dart`
- **Service:** `auth_service.dart`
- **Model:** `auth_response.dart`

*Login com redirecionamento para dashboard após sucesso*

#### HU003 - Recuperar Senha
- **View:** `views/auth/reset_password_view.dart`
- **ViewModel:** `auth_viewmodel.dart`
- **Service:** `auth_service.dart`

*Solicitação e confirmação via token UUID*

### Gestão de Condomínio

#### HU004 - Pesquisar Condomínio
- **Views:** 
  - `condominio_search_view.dart`
  - `condominio_detail_view.dart`
- **ViewModel:** `condominio_viewmodel.dart`
- **Service:** `condominio_service.dart`
- **Model:** `condominio_model.dart`

*Lista com filtros, ordenação e modal de detalhes*

#### HU005 - Manter Apartamento
- **View:** `apartamento_view.dart`
- **ViewModel:** `apartamento_viewmodel.dart`
- **Service:** `apartamento_service.dart`
- **Models:** `apartamento_model.dart`, `user_model.dart`

*Troca, vínculo e desvinculação de moradores*

#### HU006 - Manter Condômino/Usuário
- **View:** `user_management_view.dart`
- **ViewModel:** `user_viewmodel.dart`
- **Service:** `user_service.dart`
- **Model:** `user_model.dart`

*CRUD de usuários com controle de perfis e status*

### Chamados

#### HU007 - Manter Chamado
- **View:** `chamado_list_view.dart`
- **ViewModel:** `chamado_viewmodel.dart`
- **Service:** `chamado_service.dart`
- **Model:** `chamado_model.dart`

*Listar, editar status e excluir com controle de permissões*

#### HU008 - Adicionar Chamado
- **View:** `chamado_form_view.dart`
- **ViewModel:** `chamado_viewmodel.dart`

*Criação com atualização em tempo real da lista*

---
## Estratégia de Testes

### `test/core/`
Utilitários independentes
- Validação de CPF/senha
- Interceptadores de API

### `test/models/`
Serialização de dados
- `fromJson` / `toJson`
- Igualdade entre objetos
- Método `copyWith`

### `test/services/`
Integração com API
- Mock com `mockito` ou `http_mock_adapter`
- Validação de tokens e respostas

### `test/viewmodels/`
Regras de negócio
- Estados da aplicação
- Fluxos sem dependência da UI

### `test/views/`
Interface do usuário
- Testes de widget
- Golden tests
- Interação com componentes

### `test/integration/`
Fluxos end-to-end
- Simulação de jornadas completas
- Integração entre módulos

---
## Como executar o projeto

### Pré-requisitos
- Flutter SDK instalado
- Android Studio ou Xcode (para iOS)
- Dispositivo físico ou emulador configurado

### Configuração do ambiente
1. Verifique se o Flutter está instalado:
```bash
flutter --version
```

2. Verifique se há problemas na configuração:
```bash
flutter doctor
```

3. Instale as dependências do projeto:
```bash
flutter pub get
```

### Executar o projeto
1. Liste os dispositivos disponíveis:
```bash
flutter devices
```

2. Execute o aplicativo:
```bash
flutter run
```

3. Para executar em um dispositivo específico:
```bash
flutter run -d <device-id>
```

4. Para executar em modo debug:
```bash
flutter run --debug
```

5. Para executar em modo release:
```bash
flutter run --release
```

---
## Atualização de ícones

Para atualizar os ícones do aplicativo Flutter, utilize o comando:
 
```bash
flutter pub run flutter_launcher_icons
```
 
Este comando gera e atualiza os ícones do aplicativo para diferentes plataformas,
conforme configurado no arquivo `pubspec.yaml` usando o pacote `flutter_launcher_icons`.
Certifique-se de definir corretamente as opções de ícone no `pubspec.yaml` antes de executar o comando.

---
## Desenvolvimento Local com Servidor Mock

Para facilitar o desenvolvimento e os testes da UI sem depender de um backend real, o projeto inclui um servidor mock.

### 1. Rodando o Servidor Mock

O servidor simula a API real e fornece dados para autenticação e outras funcionalidades.

```bash
# 1. Navegue até a pasta do servidor
cd mock_server

# 2. Instale as dependências (apenas na primeira vez)
npm install

# 3. Inicie o servidor
node server.js
```

O servidor estará rodando em `http://localhost:8080` e pronto para receber requisições.

### 2. Configurando o App Flutter

Para que o aplicativo (especialmente em um emulador ou dispositivo físico) consiga se comunicar com o servidor rodando na sua máquina, você precisa usar o endereço de IP da sua rede local.

#### Encontrando seu IP Local

- **No macOS / Linux:**
  ```bash
  ipconfig getifaddr en0
  # ou
  ifconfig | grep "inet " | grep -v 127.0.0.1
  ```

- **No Windows:**
  ```bash
  ipconfig | findstr "IPv4"
  ```
  Procure pelo endereço IPv4 do seu adaptador de Wi-Fi ou Ethernet.

### 3. Executando o App com Variáveis de Ambiente

A melhor forma de informar o IP para o app é através de variáveis de ambiente, usando a flag `--dart-define`. Isso evita que você precise alterar o código-fonte.

Substitua `<SEU_IP_LOCAL>` pelo endereço que você encontrou no passo anterior.

```bash
flutter run --dart-define="API_BASE_URL=http://<SEU_IP_LOCAL>:8080"
```

**Exemplo:**
```bash
flutter run --dart-define="API_BASE_URL=http://192.168.1.100:8080"
```

O código do aplicativo está configurado para ler essa variável. Se ela não for fornecida, ele tentará usar uma configuração padrão para emuladores.

#### Configurando o Ambiente de Execução na IDE

Para não precisar digitar o comando no terminal toda vez, você pode configurar a variável de ambiente diretamente na sua IDE.

##### Visual Studio Code

1.  Abra o arquivo `.vscode/launch.json` na raiz do projeto.
2.  Adicione uma configuração de inicialização com o campo `args`. Substitua pelo seu IP.

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Condo Connect (Mock API)",
            "request": "launch",
            "type": "dart",
            "args": [
                "--dart-define",
                "API_BASE_URL=http://10.0.0.158:8080"
            ]
        },
        {
            "name": "Condo Connect (Default)",
            "request": "launch",
            "type": "dart"
        }
    ]
}
```
Agora você pode selecionar "Condo Connect (Mock API)" no menu "Run and Debug" (Cmd+Shift+D) para iniciar com a configuração.

##### IntelliJ IDEA / Android Studio

1.  Vá em `Run > Edit Configurations...`.
2.  Selecione a configuração de execução do Flutter (geralmente chamada de `main.dart`).
3.  No campo **"Additional run args"**, adicione a flag. Substitua pelo seu IP.

```
--dart-define="API_BASE_URL=http://192.168.1.100:8080"
```
4.  Clique em "Apply" e "OK". Agora, ao executar o projeto, a variável será aplicada automaticamente