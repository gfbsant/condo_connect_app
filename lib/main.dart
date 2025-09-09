import 'package:condo_connect/app/core/storage/secure_storage.dart';
import 'package:condo_connect/app/core/theme/app_themes.dart';
import 'package:condo_connect/app/data/repositories/user_preferences_repository_impl.dart';
import 'package:condo_connect/app/features/auth/view/auth_wrapper.dart';
import 'package:condo_connect/app/features/auth/view/login_view.dart';
import 'package:condo_connect/app/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:condo_connect/app/data/repositories/auth_repository_impl.dart';
import 'package:condo_connect/app/features/dashboard/view/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(client: http.Client()),
        ),
        Provider<SecureStorage>(
          create: (_) => SecureStorage(),
        ),
        Provider<UserPreferencesRepository>(
          create: (_) =>
              UserPreferencesRepository(preferences: sharedPreferences),
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
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginView(),
          '/dashboard': (context) => const DashboardView(),
        },
      ),
    );
  }
}
