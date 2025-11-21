import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearErrorOnInteraction);
    _passwordController.addListener(_clearErrorOnInteraction);
  }

  void _clearErrorOnInteraction() {
    final AuthState authState = ref.read(authNotifierProvider);
    if (authState.errorMessage != null) {
      ref.read(authNotifierAccessor).clearError();
    }
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(authNotifierAccessor)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(final BuildContext context) {
    final AuthState authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (
      final previous,
      final next,
    ) async {
      if (next.status == AuthStatus.authenticated && mounted) {
        await Navigator.pushReplacementNamed(context, '/dashboard');
      } else if (next.status == AuthStatus.error &&
          next.errorMessage != null &&
          mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        await Future.microtask(
          () => ref.read(authNotifierAccessor).clearError(),
        );
      }
    });
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Header(),
                  const SizedBox(height: 8),
                  _EmailField(
                    controller: _emailController,
                    isEnabled: authState.status != AuthStatus.loading,
                  ),
                  const SizedBox(height: 16),
                  _PasswordField(
                    controller: _passwordController,
                    isEnabled: authState.status != AuthStatus.loading,
                  ),
                  const SizedBox(height: 8),
                  const _ForgotPasswordLink(),
                  const SizedBox(height: 24),
                  _LoginButton(
                    isLoading: authState.status == AuthStatus.loading,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 24),
                  const _RegisterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.removeListener(_clearErrorOnInteraction);
    _passwordController.removeListener(_clearErrorOnInteraction);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Image.asset(
          'assets/icon/icon.png',
          width: 80,
          height: 80,
          errorBuilder: (final context, final error, final stackTrace) =>
              Icon(Icons.apartment, size: 80, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'Bem-vindo de volta',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Entre para acessar seu condomínio digital',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    keyboardType: TextInputType.emailAddress,
    validator: Validators.validateEmail,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.email_outlined),
      labelText: 'Email',
      hintText: 'seu.email@exemplo.com',
    ),
    textInputAction: TextInputAction.next,
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>('controller', controller),
      )
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled));
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>('controller', controller),
      )
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled));
  }
}

class _PasswordFieldState extends State<_PasswordField> {
  var _obscurePassword = true;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: widget.controller,
    enabled: widget.isEnabled,
    obscureText: _obscurePassword,
    validator: Validators.validatePassword,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.lock_outline),
      labelText: 'Senha',
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    ),
    textInputAction: TextInputAction.done,
    onFieldSubmitted: (_) {
      if (widget.isEnabled) {
        // Trigger login quando pressionar Enter
      }
    },
  );
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      elevation: 4,
    ),
    child: SizedBox(
      height: 24,
      child: isLoading
          ? Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            )
          : const Text(
              'ENTRAR',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}

class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink();

  @override
  Widget build(final BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: TextButton(
      onPressed: () => Navigator.pushNamed(context, '/reset-password'),
      child: const Text('Esqueci minha senha'),
    ),
  );
}

class _RegisterLink extends StatelessWidget {
  const _RegisterLink();

  @override
  Widget build(final BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Não tem uma conta?'),
      TextButton(
        onPressed: () => Navigator.pushNamed(context, '/register'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('Crie agora'),
      ),
    ],
  );
}
