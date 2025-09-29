import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/validators.dart';
import '../../../data/models/auth_state.dart';
import '../viewmodel/auth_viewmodel.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AuthViewModel _authViewModel;

  var _isTokenStep = false;

  @override
  void initState() {
    super.initState();
    _authViewModel = context.read<AuthViewModel>();
    _authViewModel.addListener(_handleStateChanges);

    WidgetsBinding.instance.addPostFrameCallback((final _) {
      _authViewModel.resetToInitialState();
    });
  }

  Future<void> _handleStateChanges() async {
    if (!mounted) {
      return;
    }

    if (_authViewModel.state == AuthState.success) {
      if (!_isTokenStep) {
        await HapticFeedback.lightImpact();
        _showSuccessSnackBar(
          'Código enviado para ${_emailController.text.trim()}',
        );
        setState(() {
          _isTokenStep = true;
        });
        _authViewModel.resetToInitialState();
      } else {
        await HapticFeedback.mediumImpact();
        await _showSuccessDialog();
      }
    } else if (_authViewModel.errorMessage != null) {
      _showErrorSnackBar(_authViewModel.errorMessage!);
      _authViewModel.clearError();
    }
  }

  void _showSuccessSnackBar(final String message, {final Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          spacing: 8,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 3),
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
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
        icon: Container(),
      ),
    );
  }

  Future<void> _handleRequestReset() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _authViewModel.requestPasswordReset(_emailController.text.trim());
  }

  Future<void> _handleConfirmReset() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    await _authViewModel.confirmPasswordReset(
      _tokenController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(final BuildContext context) => Consumer<AuthViewModel>(
        child: const SizedBox(height: 8),
        builder: (final context, final authViewModel, final spacer) => Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text(_isTokenStep ? 'Nova Senha' : 'Recuperar Senha'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(isTokenStep: _isTokenStep),
                    const SizedBox(
                      height: 40,
                    ),
                    if (!_isTokenStep) ...[
                      _EmailField(
                        controller: _emailController,
                        isEnabled: !authViewModel.isLoading,
                      ),
                      spacer!,
                      _RequestResetButton(
                        isLoading: authViewModel.isLoading,
                        onPressed: _handleRequestReset,
                      ),
                    ] else ...[
                      _TokenField(
                        controller: _tokenController,
                        isEnabled: !authViewModel.isLoading,
                      ),
                      _PasswordField(
                        controller: _passwordController,
                        isEnabled: !authViewModel.isLoading,
                      ),
                      _ConfirmPasswordField(
                        controller: _confirmPasswordController,
                        passwordController: _passwordController,
                        isEnabled: !authViewModel.isLoading,
                      ),
                      spacer!,
                      _ConfirmResetButton(
                        isLoading: authViewModel.isLoading,
                        onPressed: _handleConfirmReset,
                      ),
                      _BackToEmailButton(
                        onPressed: () {
                          setState(() {
                            _isTokenStep = false;
                            _tokenController.clear();
                            _passwordController.clear();
                            _confirmPasswordController.clear();
                          });
                        },
                      ),
                    ],
                    spacer,
                    const _BackToLoginLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _authViewModel.removeListener(_handleStateChanges);
    _emailController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isTokenStep});
  final bool isTokenStep;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      spacing: 12,
      children: [
        Icon(
          isTokenStep ? Icons.lock_reset : Icons.email_outlined,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
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
  const _EmailField({
    required this.controller,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: controller,
        enabled: isEnabled,
        keyboardType: TextInputType.emailAddress,
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
  const _TokenField({
    required this.controller,
    required this.isEnabled,
  });

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
  const _PasswordField({
    required this.controller,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final bool isEnabled;

  @override
  State<_PasswordField> createState() => __PasswordFieldState();

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

class __PasswordFieldState extends State<_PasswordField> {
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
  State<_ConfirmPasswordField> createState() => __ConfirmPasswordFieldState();

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

class __ConfirmPasswordFieldState extends State<_ConfirmPasswordField> {
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
      );
}

class _RequestResetButton extends StatelessWidget {
  const _RequestResetButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: SizedBox(
          height: 16,
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                )
              : const Text(
                  'Enviar Código',
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

class _ConfirmResetButton extends StatelessWidget {
  const _ConfirmResetButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: SizedBox(
          height: 16,
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

class _BackToEmailButton extends StatelessWidget {
  const _BackToEmailButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Voltar para Email',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
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
