import 'package:flutter/foundation.dart'
    show DiagnosticPropertiesBuilder, DiagnosticsProperty;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/core/storage/secure_storage.dart';
import 'app/core/theme/app_themes.dart';
import 'app/data/repositories/user_preferences_repository.dart';
import 'app/data/services/auth_service.dart';
import 'app/features/auth/view/auth_wrapper.dart';
import 'app/features/auth/view/login_view.dart';
import 'app/features/auth/view/register_view.dart';
import 'app/features/auth/view/reset_password_view.dart';
import 'app/features/auth/viewmodel/auth_viewmodel.dart';
import 'app/features/dashboard/view/dashboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.sharedPreferences, super.key});
  final SharedPreferences sharedPreferences;

  @override
  Widget build(final BuildContext context) => MultiProvider(
        providers: [
          Provider<SecureStorage>(
            create: (final _) => SecureStorage(),
          ),
          Provider<UserPreferencesRepository>(
            create: (final _) =>
                UserPreferencesRepository(preferences: sharedPreferences),
          ),
          Provider<AuthService>(
            create: (final context) => AuthService(),
          ),
          ChangeNotifierProxyProvider2<AuthService, SecureStorage,
              AuthViewModel>(
            create: (final context) => AuthViewModel(
              authService: context.read<AuthService>(),
              storage: context.read<SecureStorage>(),
            ),
            update: (
              final context,
              final authService,
              final storage,
              final previous,
            ) =>
                previous ??
                AuthViewModel(
                  authService: authService,
                  storage: storage,
                ),
          ),
        ],
        child: MaterialApp(
          title: 'Condo Connect',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          debugShowCheckedModeBanner: false,
          home: const AuthWrapper(),
          routes: {
            '/login': (final context) => const LoginView(),
            '/register': (final context) => const RegisterView(),
            '/dashboard': (final context) => const DashboardView(),
            '/reset-password': (final context) => const ResetPasswordView(),
          },
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<SharedPreferences>(
        'sharedPreferences',
        sharedPreferences,
      ),
    );
  }
}
