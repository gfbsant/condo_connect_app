import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/dashboard_page.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';
import 'login_page.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) async {
      await _checkInitialAuthStatus();
    });
  }

  Future<void> _checkInitialAuthStatus() async {
    await ref.read(authNotifierAccessor).checkAuthStatus();
  }

  @override
  Widget build(final BuildContext context) {
    final AuthState authState = ref.watch(authNotifierProvider);

    return switch (authState.status) {
      AuthStatus.loading => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      AuthStatus.authenticated => const DashgboardPage(),
      AuthStatus.unauthenticated ||
      AuthStatus.initial ||
      AuthStatus.error ||
      AuthStatus.success => const LoginPage(),
    };
  }
}
