import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/validators.dart';
import '../../domain/entities/facility_entity.dart';
import '../providers/facility_notifier.dart';
import '../providers/facility_providers.dart';

class FacilityFormPage extends ConsumerStatefulWidget {
  const FacilityFormPage({
    required this.condominiumId,
    this.facility,
    super.key,
  });

  final int condominiumId;
  final FacilityEntity? facility;

  @override
  ConsumerState<FacilityFormPage> createState() => _FacilityFormPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('condominiumId', condominiumId))
      ..add(DiagnosticsProperty<FacilityEntity?>('facility', facility));
  }
}

class _FacilityFormPageState extends ConsumerState<FacilityFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _taxController = TextEditingController();

  bool get _isEditing => widget.facility != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    final FacilityEntity? facility = widget.facility;
    if (facility != null) {
      _nameController.text = facility.name;
      _descriptionController.text = facility.description ?? '';
      if (facility.tax != null) {
        _taxController.text = (facility.tax! / 100).toStringAsFixed(2);
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen<String?>(
        facilityNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen(
        facilityNotifierProvider.select((final state) => state.successMessage),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );

    final bool isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: FacilityFormAppBar(isEditing: _isEditing),
      body: FacilityFormBody(
        formKey: _formKey,
        nameController: _nameController,
        descriptionController: _descriptionController,
        taxController: _taxController,
        isEditing: _isEditing,
        isLoading: isLoading,
        onSubmit: _handleSubmit,
      ),
    );
  }

  void _clearMessages() {
    ref.read(facilityNotifierAccessor).clearMessages();
  }

  void _showErrorSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: .floating,
      ),
    );
  }

  void _showSuccessSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          spacing: 8,
          children: [
            const Icon(Icons.check_circle),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: .floating,
      ),
    );
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    final String nameText = _nameController.text.trim();
    final String? descriptionText =
        _descriptionController.text.trim().isNotEmpty
        ? _descriptionController.text.trim()
        : null;

    int? taxValue;
    if (_taxController.text.trim().isNotEmpty) {
      final double? taxDouble = double.tryParse(
        _taxController.text.trim().replaceAll(',', '.'),
      );
      if (taxDouble != null) {
        taxValue = (taxDouble * 100).round();
      }
    }

    final facility = FacilityEntity(
      id: _isEditing ? widget.facility?.id : null,
      name: nameText,
      description: descriptionText,
      tax: taxValue,
    );

    final FacilityNotifier notifier = ref.read(facilityNotifierAccessor);

    var success = false;

    if (_isEditing) {
      final int? id = widget.facility?.id;
      if (id != null) {
        success = await notifier.updateFacility(id, facility);
      }
    } else {
      success = await notifier.createFacility(widget.condominiumId, facility);
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
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _taxController.dispose();
    super.dispose();
  }
}

class FacilityFormAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FacilityFormAppBar({required this.isEditing, super.key});

  final bool isEditing;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: Text(isEditing ? 'Editar Área Comum' : 'Nova Área Comum'),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isEditing', isEditing));
  }
}

class FacilityFormBody extends StatelessWidget {
  const FacilityFormBody({
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.taxController,
    required this.isEditing,
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController taxController;
  final bool isEditing;
  final bool isLoading;
  final Future<void> Function() onSubmit;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: formKey,
        autovalidateMode: .onUserInteraction,
        child: Column(
          spacing: 16,
          crossAxisAlignment: .stretch,
          children: [
            _Header(isEditing: isEditing),
            const SizedBox(height: 16),
            _NameField(controller: nameController, isEnabled: !isLoading),
            _DescriptionField(
              controller: descriptionController,
              isEnabled: !isLoading,
            ),
            _TaxField(controller: taxController, isEnabled: !isLoading),
            const SizedBox(height: 16),
            _SubmitButton(
              onPressed: onSubmit,
              isLoading: isLoading,
              isEditing: isEditing,
            ),
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
          'nameController',
          nameController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'descriptionController',
          descriptionController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'taxDescription',
          taxController,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isEditing', isEditing))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onSubmit', onSubmit),
      );
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
          isEditing ? Icons.edit_outlined : Icons.add_business_outlined,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
        Text(
          isEditing
              ? 'Atualize as informações da área comum'
              : 'Preencha as informações da área comum',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: .center,
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
      prefixIcon: Icon(Icons.meeting_room),
      labelText: 'Nome da Área Comum',
      hintText: 'Ex: Salão de Festas, Churrasqueira',
    ),
    textInputAction: .next,
    textCapitalization: .words,
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

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.description),
      labelText: 'Descrição (Opcional)',
      hintText: 'Detalhes da área comum',
    ),
    textInputAction: .next,
    textCapitalization: .sentences,
    maxLength: 100,
    maxLines: 3,
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

class _TaxField extends StatelessWidget {
  const _TaxField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      icon: Icon(Icons.attach_money),
      hintText: 'Taxa (Opcional)',
      prefixText: r'R$',
    ),
    keyboardType: const .numberWithOptions(decimal: true),
    textInputAction: .done,
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
    required this.onPressed,
    required this.isLoading,
    required this.isEditing,
  });

  final Future<void> Function() onPressed;
  final bool isLoading;
  final bool isEditing;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    style: ElevatedButton.styleFrom(padding: const .symmetric(vertical: 16)),
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
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            )
          : Text(
              isEditing ? 'Atualizar' : 'Criar',
              style: const TextStyle(fontWeight: .bold, fontSize: 16),
            ),
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onPressed', onPressed),
      )
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(DiagnosticsProperty<bool>('isEditing', isEditing));
  }
}
