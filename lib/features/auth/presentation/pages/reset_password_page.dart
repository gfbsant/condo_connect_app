import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/validators.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _isTokenStep = false;

  AuthNotifier get _notifierAccessor => ref.read(authNotifierAccessor);

  void _showSuccessSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    await HapticFeedback.mediumImpact();

    if (!mounted) {
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle, color: Colors.green[600], size: 48),
        ),
        title: const Text(
          'Senha Redefinida!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Sua senha foi alterada com sucesso. Você já pode fazer login '
          'com a nova senha.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Navigator.of(context).pushReplacementNamed('/login');
            },
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Fazer Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final AuthState authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;
    ref.listen<AuthState>(authNotifierProvider, (
      final previous,
      final next,
    ) async {
      if (next.status == AuthStatus.success) {
        if (!_isTokenStep) {
          await HapticFeedback.lightImpact();

          _showSuccessSnackBar(
            'Código enviado para ${_emailController.text.trim()}',
          );

          setState(() => _isTokenStep = true);

          await Future.microtask(() => _notifierAccessor.clearError());
        } else {
          await _showSuccessDialog();
        }
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        _showErrorSnackBar(next.errorMessage!);
        await Future.microtask(() => _notifierAccessor.clearError());
      }
    });
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ResetPasswordAppBar(tokenStep: _isTokenStep),
      body: ResetPasswordBody(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        tokenController: _tokenController,
        isLoading: isLoading,
        isTokenStep: _isTokenStep,
        requestResetCallback: _handleRequestReset,
        confirmResetCallback: _handleConfirmReset,
        returnCallback: _clearItems,
      ),
    );
  }

  void _clearItems() {
    setState(() {
      _isTokenStep = false;
      _tokenController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<void> _handleRequestReset() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _notifierAccessor.requestPasswordReset(
      email: _emailController.text.trim(),
    );
  }

  Future<void> _handleConfirmReset() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _notifierAccessor.confirmPasswordReset(
      token: _tokenController.text.trim(),
      newPassword: _passwordController.text,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class ResetPasswordAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ResetPasswordAppBar({required this.tokenStep, super.key});

  final bool tokenStep;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: Text(tokenStep ? 'Nova Senha' : 'Recuperar Senha'),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('tokenStep', tokenStep));
  }
}

class ResetPasswordBody extends StatelessWidget {
  const ResetPasswordBody({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.tokenController,
    required this.isLoading,
    required this.isTokenStep,
    required this.requestResetCallback,
    required this.confirmResetCallback,
    required this.returnCallback,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController tokenController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isTokenStep;
  final bool isLoading;
  final Future<void> Function() requestResetCallback;
  final Future<void> Function() confirmResetCallback;
  final VoidCallback returnCallback;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(isTokenStep: isTokenStep),
            const SizedBox(height: 40),
            if (!isTokenStep) ...[
              _EmailField(controller: emailController, isEnabled: !isLoading),
              const SizedBox(height: 24),
              _RequestResetButton(
                isLoading: isLoading,
                onPressed: requestResetCallback,
              ),
            ] else ...[
              _TokenField(controller: tokenController, isEnabled: !isLoading),
              const SizedBox(height: 16),
              _PasswordField(
                controller: passwordController,
                isEnabled: !isLoading,
              ),
              const SizedBox(height: 16),
              _ConfirmPasswordField(
                controller: confirmPasswordController,
                passwordController: passwordController,
                isEnabled: !isLoading,
              ),
              const SizedBox(height: 24),
              _ConfirmResetButton(
                isLoading: isLoading,
                onPressed: confirmResetCallback,
              ),
              const SizedBox(height: 12),
              _BackToEmailButton(onPressed: returnCallback),
            ],
            const SizedBox(height: 24),
            const _BackToLoginLink(),
          ],
        ),
      ),
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<GlobalKey<FormState>>('formKey', formKey))
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'emailController',
          emailController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'tokenController',
          tokenController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'passwordController',
          passwordController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'confirmPasswordController',
          confirmPasswordController,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isTokenStep', isTokenStep))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'requestResetCallback',
          requestResetCallback,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'confirmResetCallback',
          confirmResetCallback,
        ),
      )
      ..add(
        ObjectFlagProperty<VoidCallback>.has('returnCallback', returnCallback),
      );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isTokenStep});
  final bool isTokenStep;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Icon(
          isTokenStep ? Icons.lock_reset : Icons.email_outlined,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(height: 12),
        Text(
          isTokenStep
              ? 'Digite o código recebido por email e sua nova senha'
              : 'Digite seu email para receber as instruções de recuperação',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isTokenStep', isTokenStep));
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
      helperText: 'Enviaremos as instruções para este email',
    ),
    textInputAction: TextInputAction.done,
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

class _TokenField extends StatelessWidget {
  const _TokenField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    validator: Validators.validateResetPassToken,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.confirmation_number_outlined),
      labelText: 'Código de Recuperação',
      hintText: 'Digite o código recebido por email',
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
      labelText: 'Nova Senha',
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
    ),
    textInputAction: TextInputAction.next,
  );
}

class _ConfirmPasswordField extends StatefulWidget {
  const _ConfirmPasswordField({
    required this.controller,
    required this.passwordController,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final TextEditingController passwordController;
  final bool isEnabled;

  @override
  State<_ConfirmPasswordField> createState() => _ConfirmPasswordFieldState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>('controller', controller),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'passwordController',
          passwordController,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled));
  }
}

class _ConfirmPasswordFieldState extends State<_ConfirmPasswordField> {
  var _obscurePassword = true;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: widget.controller,
    enabled: widget.isEnabled,
    obscureText: _obscurePassword,
    validator: (final value) => Validators.validateConfirmPassword(
      value,
      widget.passwordController.text,
    ),
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.lock_outline),
      labelText: 'Confirmar Nova Senha',
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
    ),
    textInputAction: TextInputAction.done,
  );
}

class _RequestResetButton extends StatelessWidget {
  const _RequestResetButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
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
            'Enviar Código',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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

class _ConfirmResetButton extends StatelessWidget {
  const _ConfirmResetButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
              'Redefinir Senha',
              style: TextStyle(fontWeight: FontWeight.bold),
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

class _BackToEmailButton extends StatelessWidget {
  const _BackToEmailButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 8),
    ),
    child: const Text(
      'Voltar para Email',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed),
    );
  }
}

class _BackToLoginLink extends StatelessWidget {
  const _BackToLoginLink();

  @override
  Widget build(final BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Lembrou da Senha?'),
      TextButton(
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('Fazer Login'),
      ),
    ],
  );
}
