import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/validators.dart';
import '../../domain/entities/apartment_entity.dart';
import '../providers/apartment_notifier.dart';
import '../providers/apartment_providers.dart';

class ApartmentFormPage extends ConsumerStatefulWidget {
  const ApartmentFormPage({
    required this.condominiumId,
    this.apartment,
    super.key,
  });

  final int condominiumId;
  final ApartmentEntity? apartment;

  @override
  ConsumerState<ApartmentFormPage> createState() => _ApartmentFormPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('condominiumId', condominiumId))
      ..add(DiagnosticsProperty<ApartmentEntity?>('apartment', apartment));
  }
}

class _ApartmentFormPageState extends ConsumerState<ApartmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _floorController = TextEditingController();
  final _doorController = TextEditingController();
  final _towerController = TextEditingController();

  var _isRented = false;

  bool get _isEditing => widget.apartment != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    final ApartmentEntity? apartment = widget.apartment;
    if (apartment != null) {
      _numberController.text = apartment.number;
      _floorController.text = apartment.floor ?? '';
      _doorController.text = apartment.door ?? '';
      _towerController.text = apartment.tower ?? '';
      _isRented = apartment.rented ?? false;
    }
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen<String?>(
        apartmentNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen<String?>(
        apartmentNotifierProvider.select((final state) => state.successMessage),
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
      appBar: ApartmentFormAppBar(isEditing: _isEditing),
      body: ApartmentFormBody(
        formKey: _formKey,
        numberController: _numberController,
        doorController: _doorController,
        floorController: _floorController,
        towerController: _towerController,
        isEditing: _isEditing,
        isLoading: isLoading,
        isRented: _isRented,
        onRentedChanged: _updateRented,
        onSubmit: _handleSubmit,
      ),
    );
  }

  void _clearMessages() {
    ref.read(apartmentNotifierAccessor).clearMessages();
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
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
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

    final String numberText = _numberController.text.trim();
    final String? floorText = _floorController.text.trim().isNotEmpty
        ? _floorController.text.trim()
        : null;
    final String? doorText = _doorController.text.trim().isNotEmpty
        ? _doorController.text.trim()
        : null;
    final String? towerText = _towerController.text.trim().isNotEmpty
        ? _towerController.text.trim()
        : null;

    final apartment = ApartmentEntity(
      id: _isEditing ? widget.apartment?.id : null,
      number: numberText,
      floor: floorText,
      door: doorText,
      tower: towerText,
      rented: _isRented,
      condominiumId: widget.condominiumId,
      active: widget.apartment?.active,
      residents: widget.apartment?.residents,
    );

    final ApartmentNotifier notifier = ref.read(apartmentNotifierAccessor);

    var success = false;

    if (_isEditing) {
      final int? id = widget.apartment?.id;
      if (id != null) {
        success = await notifier.updateApartment(id, apartment);
      }
    } else {
      success = await notifier.createApartment(apartment);
    }

    if (success) {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _updateRented(final bool? newValue) {
    if (newValue != null) {
      setState(() => _isRented = newValue);
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _floorController.dispose();
    _doorController.dispose();
    _towerController.dispose();
    super.dispose();
  }
}

class ApartmentFormAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ApartmentFormAppBar({required this.isEditing, super.key});

  final bool isEditing;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: Text(isEditing ? 'Editar Apartamento' : 'Novo Apartamento'),
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

class ApartmentFormBody extends StatelessWidget {
  const ApartmentFormBody({
    required this.doorController,
    required this.floorController,
    required this.formKey,
    required this.isEditing,
    required this.isLoading,
    required this.isRented,
    required this.numberController,
    required this.onRentedChanged,
    required this.onSubmit,
    required this.towerController,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController numberController;
  final TextEditingController floorController;
  final TextEditingController doorController;
  final TextEditingController towerController;
  final bool isRented;
  final bool isLoading;
  final bool isEditing;
  final ValueChanged<bool?> onRentedChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const .symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: formKey,
        autovalidateMode: .onUserInteraction,
        child: Column(
          spacing: 16,
          crossAxisAlignment: .stretch,
          children: [
            _Header(isEditing: isEditing),
            const SizedBox(height: 16),
            _NumberField(controller: numberController, isEnabled: !isLoading),
            _FloorField(controller: floorController, isEnabled: !isLoading),
            _DoorField(controller: doorController, isEnabled: !isLoading),
            _TowerField(controller: towerController, isEnabled: !isLoading),
            _RentedSwitch(
              isEnabled: !isLoading,
              isRented: isRented,
              onChanged: onRentedChanged,
            ),
            const SizedBox(height: 16),
            _SubmitButton(
              isEditing: isEditing,
              isLoading: isLoading,
              onPressed: onSubmit,
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
          'numberController',
          numberController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'floorController',
          floorController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'doorController',
          doorController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'towerController',
          towerController,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isRented', isRented))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(DiagnosticsProperty<bool>('isEditing', isEditing))
      ..add(
        ObjectFlagProperty<ValueChanged<bool?>>.has(
          'onRentedChanged',
          onRentedChanged,
        ),
      )
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
          isEditing ? Icons.edit_outlined : Icons.add_home_outlined,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
        Text(
          isEditing
              ? 'Atualize as informações do apartamento'
              : 'Preencha as informações do apartamento',
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
      labelText: 'Número do Apartamento',
      hintText: 'Ex: 101, 202, etc.',
    ),
    textInputAction: .next,
    textCapitalization: .characters,
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

class _FloorField extends StatelessWidget {
  const _FloorField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.layers),
      labelText: 'Andar (Opcional)',
      hintText: 'Ex: 1, 2, 10',
    ),
    textInputAction: .next,
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

class _DoorField extends StatelessWidget {
  const _DoorField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.door_front_door),
      labelText: 'Porta (Opcionao)',
      hintText: 'Ex: A, B, 1',
    ),
    textInputAction: .next,
    textCapitalization: .characters,
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

class _TowerField extends StatelessWidget {
  const _TowerField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.business),
      labelText: 'Torre (Opcional)',
      hintText: 'Ex: A, B, 1',
    ),
    textInputAction: .next,
    textCapitalization: .characters,
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

class _RentedSwitch extends StatelessWidget {
  const _RentedSwitch({
    required this.isEnabled,
    required this.isRented,
    required this.onChanged,
  });

  final bool isRented;
  final bool isEnabled;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: SwitchListTile(
        value: isRented,
        onChanged: isEnabled ? onChanged : null,
        title: const Text('Aluguel'),
        subtitle: Text(
          isRented
              ? 'Este apartamento está alugado'
              : 'Este apartamento não está alugado',
          style: theme.textTheme.bodySmall,
        ),
        secondary: Icon(
          isRented ? Icons.home_work : Icons.home,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isRented', isRented))
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled))
      ..add(
        ObjectFlagProperty<ValueChanged<bool?>>.has('onChanged', onChanged),
      );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.isEditing,
    required this.isLoading,
    required this.onPressed,
  });

  final Future<void> Function() onPressed;
  final bool isLoading;
  final bool isEditing;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
    onPressed: isLoading
        ? null
        : () async {
            await onPressed();
          },
    style: ElevatedButton.styleFrom(padding: const .symmetric(vertical: 8)),
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
            style: const TextStyle(fontWeight: .bold, fontSize: 12),
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
