import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/injection_container.dart';
import 'features/auth/presentation/pages/auth_wrapper.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/reset_password_page.dart';
import 'features/notice/presentation/pages/notice_detail_page.dart';
import 'shared/themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: 'Condo Connect',
    theme: AppThemes.lightTheme,
    darkTheme: AppThemes.darkTheme,
    debugShowCheckedModeBanner: false,
    home: const AuthWrapper(),
    routes: {
      '/login': (final context) => const LoginPage(),
      '/register': (final context) => const RegisterPage(),
      '/reset-password': (final context) => const ResetPasswordPage(),
    },
    onGenerateRoute: (final settings) {
      if (settings.name == '/notice-detail') {
        final Object? arguments = settings.arguments;
        if (arguments != null) {
          final noticeId = arguments as int;
          return MaterialPageRoute(
            builder: (final context) => NoticeDetailPage(noticeId: noticeId),
          );
        }
      }
      return null;
    },
  );
}
