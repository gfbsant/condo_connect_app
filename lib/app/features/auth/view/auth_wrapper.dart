import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dashboard/view/dashboard_view.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'login_view.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      context.read<AuthViewModel>().checkAuthStatus();
    });
  }

  @override
  Widget build(final BuildContext context) => Consumer<AuthViewModel>(
        builder: (final context, final authViewModel, final child) {
          if (authViewModel.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (authViewModel.isAuthenticated) {
            return const DashboardView();
          }

          return const LoginView();
        },
      );
}
