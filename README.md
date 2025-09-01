
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

## Atualização de ícones

Para atualizar os ícones do aplicativo Flutter, utilize o comando:
 
```bash
flutter pub run flutter_launcher_icons
```
 
Este comando gera e atualiza os ícones do aplicativo para diferentes plataformas,
conforme configurado no arquivo `pubspec.yaml` usando o pacote `flutter_launcher_icons`.
Certifique-se de definir corretamente as opções de ícone no `pubspec.yaml` antes de executar o comando.

