import 'package:condo_connect/app/features/auth/view/login_view.dart';
import 'package:condo_connect/app/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:condo_connect/app/features/dashboard/view/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, authViewModel, child) {
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

      return LoginView();
    });
  }
}
