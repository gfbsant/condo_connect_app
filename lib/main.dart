import 'package:condo_connect/core/storage/secure_storage.dart';
import 'package:condo_connect/services/auth_service.dart';
import 'package:condo_connect/core/theme/app_themes.dart';
import 'package:condo_connect/viewmodels/auth_viewmodel.dart';
import 'package:condo_connect/views/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(client: http.Client()),
        ),
        Provider(
          create: (_) => SecureStorage(),
        ),
        ChangeNotifierProxyProvider2<AuthService, SecureStorage, AuthViewModel>(
            create: (context) => AuthViewModel(
                authService: context.read<AuthService>(),
                storage: context.read<SecureStorage>()),
            update: (context, authService, storage, previous) =>
                previous ??
                AuthViewModel(authService: authService, storage: storage))
      ],
      child: MaterialApp(
        title: 'Condo Connect',
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const LoginView(),
        routes: {},
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
