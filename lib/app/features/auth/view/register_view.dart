import 'package:condo_connect/app/core/utils/validators.dart';
import 'package:condo_connect/app/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    _authViewModel = context.read<AuthViewModel>();
    _authViewModel.addListener(_showErrorSnackBar);
    _nameController.addListener(_clearErrorOnInteraction);
    _emailController.addListener(_clearErrorOnInteraction);
    _cpfController.addListener(_clearErrorOnInteraction);
    _phoneController.addListener(_clearErrorOnInteraction);
    _passwordController.addListener(_clearErrorOnInteraction);
    _confirmPasswordController.addListener(_clearErrorOnInteraction);
  }

  void _clearErrorOnInteraction() {
    if (_authViewModel.registerError != null) {
      _authViewModel.clearRegisterError();
    }
  }

  void _showErrorSnackBar() {
    if (_authViewModel.registerError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_authViewModel.registerError!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      return;
    }

    final phone = _phoneController.text.trim();
    final success = await _authViewModel.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      cpf: _cpfController.text,
      phone: phone.isEmpty ? null : phone,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Cadastro realizado com sucesso! Faça login para continuar'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: Consumer<AuthViewModel>(builder: (context, authViewModel, _) {
        return SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                      isEnabled: !authViewModel.isRegistering,
                    ),
                    _EmailField(
                      controller: _emailController,
                      isEnabled: !authViewModel.isRegistering,
                    ),
                    _CpfField(
                      controller: _cpfController,
                      isEnabled: !authViewModel.isRegistering,
                    ),
                    _PhoneField(
                      controller: _phoneController,
                      isEnabled: !authViewModel.isRegistering,
                    ),
                    _PasswordField(
                      controller: _passwordController,
                      isEnabled: !authViewModel.isRegistering,
                    ),
                    _ConfirmPasswordField(
                      controller: _confirmPasswordController,
                      passwordController: _passwordController,
                      isEnabled: !authViewModel.isRegistering,
                    ),
                    const SizedBox(height: 8),
                    _RegisterButton(
                      isLoading: authViewModel.isRegistering,
                      onPressed: _handleRegister,
                    ),
                    const _LoginLink(),
                  ],
                ),
              )),
        ));
      }),
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
    _authViewModel.removeListener(_showErrorSnackBar);

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
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Icon(
          Icons.person_add,
          size: 40,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          'Preencha seus dados para criar sua conta',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).hintColor,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;

  const _NameField({required this.controller, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      decoration: const InputDecoration(
        labelText: 'Nome completo',
        prefixIcon: Icon(Icons.person),
      ),
      validator: Validators.validateName,
      textCapitalization: TextCapitalization.words,
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;

  const _EmailField({
    required this.controller,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
      ),
      validator: Validators.validateEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _CpfField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;

  const _CpfField({
    required this.controller,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      decoration: const InputDecoration(
          labelText: 'CPF',
          prefixIcon: Icon(Icons.badge),
          hintText: '000.000.000-00'),
      validator: Validators.validateCPF,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _CpfFormatter(),
      ],
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;

  const _PhoneField({required this.controller, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final bool isEnabled;

  const _PasswordField({required this.controller, required this.isEnabled});

  @override
  State<_PasswordField> createState() => __PasswordFieldState();
}

class __PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.isEnabled,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Senha',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscureText = !_obscureText),
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      validator: Validators.validatePassword,
    );
  }
}

class _ConfirmPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final bool isEnabled;

  const _ConfirmPasswordField(
      {required this.controller,
      required this.passwordController,
      required this.isEnabled});

  @override
  State<_ConfirmPasswordField> createState() => __ConfirmPasswordFieldState();
}

class __ConfirmPasswordFieldState extends State<_ConfirmPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.isEnabled,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Confirmar Senha',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscureText = !_obscureText),
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      validator: (value) => Validators.validateConfirmPassword(
          value, widget.passwordController.text),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _RegisterButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Text('Criar conta'),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Já tem uma conta?'),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fazer logim'),
          )
        ],
      ),
    );
  }
}

class _CpfFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = Validators.formatCPF(newValue.text);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newText.length,
      ),
    );
  }
}

class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = Validators.formatPhone(newValue.text);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
