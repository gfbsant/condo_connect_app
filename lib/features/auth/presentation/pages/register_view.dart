import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../providers/auth_providers.dart';
import '../providers/auth_state.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_clearErrorOnInteraction);
    _emailController.addListener(_clearErrorOnInteraction);
    _cpfController.addListener(_clearErrorOnInteraction);
    _birthDateController.addListener(_clearErrorOnInteraction);
    _phoneController.addListener(_clearErrorOnInteraction);
    _passwordController.addListener(_clearErrorOnInteraction);
    _confirmPasswordController.addListener(_clearErrorOnInteraction);
  }

  void _clearErrorOnInteraction() {
    final AuthState authState = ref.read(authNotifierProvider);
    if (authState.errorMessage != null) {
      ref.read(authNotifierAccessor).clearError();
    }
  }

  void _showErrorSnackBar(final String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      return;
    }

    final String phone = _phoneController.text.trim();

    await ref
        .read(authNotifierAccessor)
        .register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          cpf: _cpfController.text,
          birthDate: _birthDateController.text.trim(),
          phone: phone.isEmpty ? null : phone,
        );
  }

  @override
  Widget build(final BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (
      final previous,
      final current,
    ) {
      if (current.status == AuthStatus.error && current.errorMessage != null) {
        _showErrorSnackBar(current.errorMessage!);
      } else if (current.status == AuthStatus.success) {
        _showSuccessSnackBar();
        Navigator.of(context).pop();
      }
    });

    final AuthState authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  const _Header(),
                  const SizedBox(height: 16),
                  _NameField(
                    controller: _nameController,
                    isEnabled: !isLoading,
                  ),
                  _EmailField(
                    controller: _emailController,
                    isEnabled: !isLoading,
                  ),
                  _CpfField(controller: _cpfController, isEnabled: !isLoading),
                  _BirthDateController(
                    controller: _birthDateController,
                    isEnabled: !isLoading,
                  ),
                  _PhoneField(
                    controller: _phoneController,
                    isEnabled: !isLoading,
                  ),
                  _PasswordField(
                    controller: _passwordController,
                    isEnabled: !isLoading,
                  ),
                  _ConfirmPasswordField(
                    controller: _confirmPasswordController,
                    passwordController: _passwordController,
                    isEnabled: !isLoading,
                  ),
                  const SizedBox(height: 8),
                  _RegisterButton(
                    isLoading: isLoading,
                    onPressed: _handleRegister,
                  ),
                  const _LoginLink(),
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
    _nameController.removeListener(_clearErrorOnInteraction);
    _emailController.removeListener(_clearErrorOnInteraction);
    _cpfController.removeListener(_clearErrorOnInteraction);
    _phoneController.removeListener(_clearErrorOnInteraction);
    _passwordController.removeListener(_clearErrorOnInteraction);
    _confirmPasswordController.removeListener(_clearErrorOnInteraction);
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      spacing: 12,
      children: [
        Icon(
          Icons.person_add_alt_outlined,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
        Text(
          'Preencha seus dados para criar sua conta',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).hintColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller, required this.isEnabled});
  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      labelText: 'Nome completo',
      prefixIcon: Icon(Icons.person),
    ),
    validator: Validators.validateName,
    textCapitalization: TextCapitalization.words,
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

class _EmailField extends StatelessWidget {
  const _EmailField({required this.controller, required this.isEnabled});
  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      labelText: 'Email',
      prefixIcon: Icon(Icons.email),
    ),
    validator: Validators.validateEmail,
    keyboardType: TextInputType.emailAddress,
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

class _CpfField extends StatelessWidget {
  const _CpfField({required this.controller, required this.isEnabled});
  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      labelText: 'CPF',
      prefixIcon: Icon(Icons.badge),
      hintText: '000.000.000-00',
    ),
    validator: Validators.validateCPF,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly, _CpfFormatter()],
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

class _BirthDateController extends StatelessWidget {
  const _BirthDateController({
    required this.controller,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      labelText: 'Data de Nascimento',
      prefixIcon: Icon(Icons.calendar_month),
      hintText: '31/12/1970',
    ),
    validator: Validators.validateBirthDate,
    keyboardType: TextInputType.datetime,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      _BirthDateFormatter(),
    ],
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

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller, required this.isEnabled});
  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      labelText: 'Telefone (opcional)',
      prefixIcon: Icon(Icons.phone),
      hintText: '(00) 00000-0000',
    ),
    validator: Validators.validatePhone,
    keyboardType: TextInputType.phone,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      _PhoneFormatter(),
    ],
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
  var _obscureText = true;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: widget.controller,
    enabled: widget.isEnabled,
    obscureText: _obscureText,
    decoration: InputDecoration(
      labelText: 'Senha',
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscureText = !_obscureText),
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
      ),
    ),
    validator: Validators.validatePassword,
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
  var _obscureText = true;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: widget.controller,
    enabled: widget.isEnabled,
    obscureText: _obscureText,
    decoration: InputDecoration(
      labelText: 'Confirmar Senha',
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscureText = !_obscureText),
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
      ),
    ),
    validator: (final value) => Validators.validateConfirmPassword(
      value,
      widget.passwordController.text,
    ),
  );
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({required this.isLoading, required this.onPressed});
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    child: isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text('CRIAR CONTA'),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Já tem uma conta?'),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fazer logim'),
        ),
      ],
    ),
  );
}

class _CpfFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    final TextEditingValue oldValue,
    final TextEditingValue newValue,
  ) {
    final String newText = Validators.formatCPF(newValue.text);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _BirthDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    final TextEditingValue oldValue,
    final TextEditingValue newValue,
  ) {
    final String newText = Validators.formatBirthDate(newValue.text);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    final TextEditingValue oldValue,
    final TextEditingValue newValue,
  ) {
    final String newText = Validators.formatPhone(newValue.text);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
