# condo_connect_app

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