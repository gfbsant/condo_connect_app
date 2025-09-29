import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/validators.dart';
import '../../../data/models/condo_model.dart';
import '../viewmodel/condo_viewmodel.dart';

class CondoFormView extends StatefulWidget {
  const CondoFormView({super.key, this.condo});

  final Condo? condo;

  @override
  State<CondoFormView> createState() => _CondoFormViewState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Condo?>('condo', condo));
  }
}

class _CondoFormViewState extends State<CondoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();

  late CondoViewModel _condoViewModel;
  bool get _isEditing => widget.condo != null;

  @override
  void initState() {
    super.initState();
    _condoViewModel = context.read<CondoViewModel>();
    _condoViewModel.addListener(_handleStateChanges);
    if (_isEditing) {
      _populateFields();
    }
  }

  void _handleStateChanges() {
    if (!mounted) {
      return;
    }

    if (_condoViewModel.errorMessage != null) {
      _showErrorSnackBar(_condoViewModel.errorMessage!);
      _condoViewModel.clearError();
    }
  }

  void _populateFields() {
    final Condo condo = widget.condo!;
    _nameController.text = condo.name;
    _cityController.text = condo.city;
    _stateController.text = condo.state;
    _neighborhoodController.text = condo.neighborhood;
    _zipcodeController.text = condo.zipcode;
    _addressController.text = condo.address;
    _numberController.text = condo.number;
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

  void _showSuccessSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          spacing: 8,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final condo = Condo(
      id: _isEditing ? widget.condo!.id : null,
      name: _nameController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      neighborhood: _neighborhoodController.text.trim(),
      zipcode: _zipcodeController.text.trim(),
      address: _addressController.text.trim(),
      number: _numberController.text.trim(),
    );

    bool success;
    if (_isEditing) {
      success = await _condoViewModel.updateCondo(widget.condo!.id!, condo);
    } else {
      success = await _condoViewModel.createCondo(condo);
    }

    if (success) {
      await HapticFeedback.lightImpact();
      _showSuccessSnackBar(
        _isEditing
            ? 'Condomínio atualizado com sucesso'
            : 'Condomínio criado com sucesso',
      );
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(final BuildContext context) => Consumer<CondoViewModel>(
        child: const SizedBox(height: 16),
        builder: (final context, final viewModel, final spacer) => Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text(_isEditing ? 'Editar Condomínio' : 'Novo Condomínio'),
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
                    _Header(isEditing: _isEditing),
                    spacer!,
                    _NameField(
                      controller: _nameController,
                      isEnabled: !viewModel.isLoading,
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _CityField(
                            controller: _cityController,
                            isEnabled: !viewModel.isLoading,
                          ),
                        ),
                        Expanded(
                          child: _StateField(
                            controller: _stateController,
                            isEnabled: !viewModel.isLoading,
                          ),
                        ),
                      ],
                    ),
                    _NeighborhoodField(
                      controller: _neighborhoodController,
                      isEnabled: !viewModel.isLoading,
                    ),
                    _ZipcodeField(
                      controller: _zipcodeController,
                      isEnabled: !viewModel.isLoading,
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _AddressField(
                            controller: _addressController,
                            isEnabled: !viewModel.isLoading,
                          ),
                        ),
                        Expanded(
                          child: _NumberField(
                            controller: _numberController,
                            isEnabled: !viewModel.isLoading,
                          ),
                        ),
                      ],
                    ),
                    spacer,
                    _SubmitButton(
                      isLoading: viewModel.isLoading,
                      isEditing: _isEditing,
                      onPressed: _handleSubmit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _condoViewModel.removeListener(_handleStateChanges);
    _nameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _neighborhoodController.dispose();
    _zipcodeController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    super.dispose();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isEditing});
  final bool isEditing;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      spacing: 12,
      children: [
        Icon(
          isEditing ? Icons.edit_outlined : Icons.apartment_outlined,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
        Text(
          isEditing
              ? 'Atualize as informações do condomínio'
              : 'Preencha as informações do novo condominio',
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
    properties.add(DiagnosticsProperty<bool>('isEditing', isEditing));
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.controller,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: controller,
        enabled: isEnabled,
        validator: Validators.validateRequired,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.apartment),
          labelText: 'Nome do Condomínio',
          hintText: 'Ex: Residencial Bela Vista',
        ),
        textInputAction: TextInputAction.next,
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

class _CityField extends StatelessWidget {
  const _CityField({
    required this.controller,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: controller,
        enabled: isEnabled,
        validator: Validators.validateRequired,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.location_city),
          labelText: 'Cidade',
          hintText: 'Ex: Curitiba',
        ),
        textInputAction: TextInputAction.next,
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

class _StateField extends StatelessWidget {
  const _StateField({
    required this.controller,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: controller,
        enabled: isEnabled,
        validator: Validators.validateState,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.map),
          labelText: 'Estado',
          hintText: 'PR',
        ),
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.characters,
        maxLength: 2,
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

class _NeighborhoodField extends StatelessWidget {
  const _NeighborhoodField({
    required this.controller,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: controller,
        enabled: isEnabled,
        validator: Validators.validateRequired,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.location_on),
          labelText: 'Bairro',
          hintText: 'Ex: Jardim das Américas',
        ),
        textInputAction: TextInputAction.next,
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

class _ZipcodeField extends StatelessWidget {
  const _ZipcodeField({
    required this.controller,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: controller,
        enabled: isEnabled,
        validator: Validators.validateZipCode,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.markunread_mailbox),
          labelText: 'CEP',
          hintText: '84324-000',
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _ZipcodeMaskFormatter(),
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

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.controller,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: controller,
        enabled: isEnabled,
        validator: Validators.validateRequired,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.home),
          labelText: 'Endereço',
          hintText: 'Ex: Rua dos Eucaliptos',
        ),
        textInputAction: TextInputAction.next,
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

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.isEnabled,
  });

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
        controller: controller,
        enabled: isEnabled,
        validator: Validators.validateRequired,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.numbers),
          labelText: 'Número',
          hintText: 'Ex: 443',
        ),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
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

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.isLoading,
    required this.isEditing,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isEditing;
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
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                )
              : Text(
                  isEditing ? 'Atualizar' : 'Criar',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(DiagnosticsProperty<bool>('isEditing', isEditing))
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}

class _ZipcodeMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    final TextEditingValue oldValue,
    final TextEditingValue newValue,
  ) {
    final String text = newValue.text;

    if (text.length <= 5) {
      return newValue;
    }

    final masked = '${text.substring(0, 5)}-'
        '${text.substring(5, text.length > 8 ? 8 : text.length)}';

    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }
}
