import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/validators.dart';
import '../../domain/entities/resident_entity.dart';
import '../providers/resident_notifier.dart';
import '../providers/resident_provider.dart';

class ResidentFormPage extends ConsumerStatefulWidget {
  const ResidentFormPage({required this.apartmentId, this.resident, super.key});

  final int apartmentId;
  final ResidentEntity? resident;

  @override
  ConsumerState<ResidentFormPage> createState() => _ResidentFormPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('apartmentId', apartmentId))
      ..add(DiagnosticsProperty<ResidentEntity?>('resident', resident));
  }
}

class _ResidentFormPageState extends ConsumerState<ResidentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  var _isOwner = false;

  bool get _isEditing => widget.resident != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    final ResidentEntity? resident = widget.resident;
    if (resident != null) {
      _isOwner = resident.owner;
    }
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen<String?>(
        residentNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen<String?>(
        residentNotifierProvider.select((final state) => state.successMessage),
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
      appBar: ResidentFormAppBar(isEditing: _isEditing),
      body: ResidentFormBody(
        formKey: _formKey,
        isEditing: _isEditing,
        isLoading: isLoading,
        isOwner: _isOwner,
        emailController: _emailController,
        userName: widget.resident?.user?.name,
        onOwnerChanged: _updateOwner,
        onSubmit: _handleSubmit,
      ),
    );
  }

  void _clearMessages() {
    ref.read(residentNotifierAccessor).clearMessages();
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

    final String email = _emailController.text.trim();

    final ResidentNotifier notifier = ref.read(residentNotifierAccessor);

    var success = false;

    if (_isEditing) {
      final int? residentId = widget.resident?.id;
      if (residentId != null) {
        final resident = ResidentEntity(id: residentId, owner: _isOwner);
        success = await notifier.updateResident(
          widget.apartmentId,
          residentId,
          resident,
        );
      }
    } else {
      success = await notifier.createResident(widget.apartmentId, email);
    }

    if (success) {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _updateOwner(final bool? newValue) {
    if (newValue != null) {
      setState(() => _isOwner = newValue);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

class ResidentFormAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ResidentFormAppBar({required this.isEditing, super.key});

  final bool isEditing;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: Text(isEditing ? 'Editar Morador' : 'Novo Morador'),
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

class ResidentFormBody extends StatelessWidget {
  const ResidentFormBody({
    required this.formKey,
    required this.emailController,
    required this.isOwner,
    required this.isLoading,
    required this.isEditing,
    required this.onOwnerChanged,
    required this.onSubmit,
    required this.userName,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final String? userName;
  final bool isOwner;
  final bool isLoading;
  final bool isEditing;
  final ValueChanged<bool?> onOwnerChanged;
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
            if (!isEditing) ...[
              _EmailField(controller: emailController, isEnabled: !isLoading),
            ] else if (userName != null) ...[
              _UserNameField(userName: userName!),
            ],
            if (isEditing)
              _OwnerSwitch(
                isEnabled: !isLoading,
                isOwner: isOwner,
                onChanged: onOwnerChanged,
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
      ..add(DiagnosticsProperty<bool>('isEditing', isEditing))
      ..add(DiagnosticsProperty<GlobalKey<FormState>>('formKey', formKey))
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'userIdController',
          emailController,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isOwner', isOwner))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(
        ObjectFlagProperty<ValueChanged<bool?>>.has(
          'onOwnerChanged',
          onOwnerChanged,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onSubmit', onSubmit),
      )
      ..add(StringProperty('userName', userName));
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
          isEditing ? Icons.edit_outlined : Icons.person_add_outlined,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
        Text(
          isEditing
              ? 'Atualize as informações do morador'
              : 'Adicione um novo morador ao apartamento',
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

class _UserNameField extends StatelessWidget {
  const _UserNameField({required this.userName});

  final String userName;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      margin: const .all(4),
      child: Padding(
        padding: const .all(16),
        child: Column(
          spacing: 8,
          crossAxisAlignment: .start,
          children: [
            Text(
              'Usuário',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: .center,
            ),
            Text(
              userName,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: .w500,
              ),
              textAlign: .center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('userName', userName));
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
    keyboardType: .emailAddress,
    validator: Validators.validateEmail,
    decoration: const InputDecoration(
      prefixIcon: Icon(Icons.email_outlined),
      labelText: 'Email',
      hintText: 'morador@exemplo.com',
    ),
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

class _OwnerSwitch extends StatelessWidget {
  const _OwnerSwitch({
    required this.isEnabled,
    required this.isOwner,
    required this.onChanged,
  });

  final bool isOwner;
  final bool isEnabled;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: SwitchListTile(
        value: isOwner,
        onChanged: isEnabled ? onChanged : null,
        title: const Text('Proprietário'),
        subtitle: Text(
          isOwner
              ? 'Este morador é o proprietário'
              : 'Este morador nao é o proprietário',
          style: theme.textTheme.bodySmall,
        ),
        secondary: Icon(
          isOwner ? Icons.star : Icons.star_border,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isOwer', isOwner))
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
    style: ElevatedButton.styleFrom(padding: const .symmetric(vertical: 12)),
    child: isLoading
        ? Center(
            child: SizedBox(
              height: 24,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          )
        : Text(
            isEditing ? 'Atualizar' : 'Adicionar',
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
