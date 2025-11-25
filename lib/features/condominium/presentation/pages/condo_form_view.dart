import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/condominium_entity.dart';
import '../providers/condo_providers.dart';

class CondoFormPage extends ConsumerStatefulWidget {
  const CondoFormPage({super.key, this.condo});

  final CondominiumEntity? condo;

  @override
  ConsumerState<CondoFormPage> createState() => _CondoFormPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CondominiumEntity?>('condo', condo));
  }
}

class _CondoFormPageState extends ConsumerState<CondoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();

  bool get _isEditing => widget.condo != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _populateFields();
    }
  }

  void _populateFields() {
    final CondominiumEntity condo = widget.condo!;
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
          children: [Icon(Icons.check_circle, color: Colors.white, size: 20)],
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

    final condo = CondominiumEntity(
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
      success = await ref
          .read(condoNotifierAccessor)
          .updateCondo(widget.condo!.id!, condo);
    } else {
      success = await ref.read(condoNotifierAccessor).createCondo(condo);
    }

    if (success) {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen<String?>(errorMessageProvider, (_, final errorMessage) {
        if (errorMessage != null) {
          _showErrorSnackBar(errorMessage);
          ref.read(condoNotifierAccessor).clearMessages();
        }
      })
      ..listen<String?>(successMessageProvider, (_, final successMessage) {
        if (successMessage != null) {
          _showSuccessSnackBar(successMessage);
          ref.read(condoNotifierAccessor).clearMessages();
        }
      });

    final bool isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
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
                const SizedBox(height: 16),
                _NameField(controller: _nameController, isEnabled: !isLoading),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _CityField(
                        controller: _cityController,
                        isEnabled: !isLoading,
                      ),
                    ),
                    Expanded(
                      child: _StateField(
                        controller: _stateController,
                        isEnabled: !isLoading,
                      ),
                    ),
                  ],
                ),
                _NeighborhoodField(
                  controller: _neighborhoodController,
                  isEnabled: !isLoading,
                ),
                _ZipcodeField(
                  controller: _zipcodeController,
                  isEnabled: !isLoading,
                ),
                Row(
                  spacing: 12,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _AddressField(
                        controller: _addressController,
                        isEnabled: !isLoading,
                      ),
                    ),
                    Expanded(
                      child: _NumberField(
                        controller: _numberController,
                        isEnabled: !isLoading,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SubmitButton(
                  isLoading: isLoading,
                  isEditing: _isEditing,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
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
  const _NameField({required this.controller, required this.isEnabled});

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
  const _CityField({required this.controller, required this.isEnabled});

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
  const _StateField({required this.controller, required this.isEnabled});

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
  const _NeighborhoodField({required this.controller, required this.isEnabled});

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
  const _ZipcodeField({required this.controller, required this.isEnabled});

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
  const _AddressField({required this.controller, required this.isEnabled});

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
  const _NumberField({required this.controller, required this.isEnabled});

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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

    final masked =
        '${text.substring(0, 5)}-'
        '${text.substring(5, text.length > 8 ? 8 : text.length)}';

    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }
}
