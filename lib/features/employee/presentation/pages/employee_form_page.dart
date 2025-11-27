import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/enums/employee_role.dart';
import '../providers/employee_notifier.dart';
import '../providers/employee_providers.dart';

class EmployeeFormPage extends ConsumerStatefulWidget {
  const EmployeeFormPage({
    required this.condominiumId,
    super.key,
    this.employee,
  });

  final int condominiumId;
  final EmployeeEntity? employee;

  @override
  ConsumerState<EmployeeFormPage> createState() => _EmployeeFormPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('condominiumId', condominiumId))
      ..add(DiagnosticsProperty<EmployeeEntity?>('employee', employee));
  }
}

class _EmployeeFormPageState extends ConsumerState<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _descriptionController = TextEditingController();

  EmployeeRole _selectedRole = EmployeeRole.colaborator;

  bool get _isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final EmployeeEntity? employee = widget.employee;
    if (employee != null) {
      _userIdController.text = employee.userId.toString();
      _descriptionController.text = employee.description ?? '';
      _selectedRole = employee.role;
    }
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen<String?>(
        employeeNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen<String?>(
        employeeNotifierProvider.select((final state) => state.successMessage),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );

    final bool isLoading = ref.read(isLoadingProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: EmployeeFormAppBar(isEditing: _isEditing),
      body: EmployeeFormBody(
        formKey: _formKey,
        userIdContoller: _userIdController,
        descriptionController: _descriptionController,
        selectedRole: _selectedRole,
        isLoading: isLoading,
        isEditing: _isEditing,
        onUpdateRole: _updateRole,
        onSubmit: _handleSubmit,
      ),
    );
  }

  void _clearMessages() {
    ref.read(employeeNotifierAccessor).clearMessages();
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

    final String descriptionText = _descriptionController.text.trim();
    final int userId = int.parse(_userIdController.text.trim());

    final employee = EmployeeEntity(
      id: _isEditing ? widget.employee?.id : null,
      userId: userId,
      condominiumId: widget.condominiumId,
      role: _selectedRole,
      description: descriptionText.isNotEmpty ? descriptionText : null,
      user: widget.employee?.user,
    );

    final EmployeeNotifier notifier = ref.read(employeeNotifierAccessor);

    var success = false;

    if (_isEditing) {
      final int? id = widget.employee?.id;
      if (id != null) {
        success = await notifier.updateEmployee(id, employee);
      }
    } else {
      success = await notifier.createEmployee(widget.condominiumId, employee);
    }

    if (success) {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _updateRole(final EmployeeRole? newRole) {
    if (newRole != null) {
      setState(() => _selectedRole = newRole);
    }
  }
}

class EmployeeFormAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EmployeeFormAppBar({required this.isEditing, super.key});

  final bool isEditing;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: Text(isEditing ? 'Editar Funcionário' : 'Novo Funcionário'),
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

class EmployeeFormBody extends StatelessWidget {
  const EmployeeFormBody({
    required this.formKey,
    required this.descriptionController,
    required this.userIdContoller,
    required this.selectedRole,
    required this.isLoading,
    required this.isEditing,
    required this.onUpdateRole,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController descriptionController;
  final TextEditingController userIdContoller;
  final EmployeeRole selectedRole;
  final bool isLoading;
  final bool isEditing;
  final ValueChanged<EmployeeRole?> onUpdateRole;
  final Future<void> Function() onSubmit;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const .symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          spacing: 16,
          crossAxisAlignment: .stretch,
          children: [
            _Header(isEditing: isEditing),
            const SizedBox(height: 16),
            _UserIdField(
              controller: userIdContoller,
              isEnabled: !isLoading && !isEditing,
            ),
            _RoleDropdown(
              onChanged: onUpdateRole,
              selectedRole: selectedRole,
              isEnabled: !isLoading,
            ),
            _DescriptionField(
              controller: descriptionController,
              isEnabled: !isLoading,
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
          'descriptionController',
          descriptionController,
        ),
      )
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'userIdContoller',
          userIdContoller,
        ),
      )
      ..add(EnumProperty<EmployeeRole>('selectedRole', selectedRole))
      ..add(DiagnosticsProperty<bool>('isEditing', isEditing))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(
        ObjectFlagProperty<ValueChanged<EmployeeRole?>>.has(
          'onUpdateRole',
          onUpdateRole,
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
          isEditing ? Icons.edit_outlined : Icons.person_add_outlined,
          size: 40,
          color: theme.colorScheme.secondary,
        ),
        Text(
          isEditing
              ? 'Atualize as informações do funcionário'
              : 'Preencha as informações do funcionário',
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

class _UserIdField extends StatelessWidget {
  const _UserIdField({required this.controller, required this.isEnabled});

  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(final BuildContext context) => TextFormField(
    controller: controller,
    enabled: isEnabled,
    validator: Validators.validateRequired,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.badge),
      labelText: 'ID do Usuário',
      hintText: 'Digite o ID do Usuário',
      helperText: isEnabled
          ? 'Este campo nao pode ser alterado após criação'
          : null,
    ),
    keyboardType: .number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

class _RoleDropdown extends StatelessWidget {
  const _RoleDropdown({
    required this.isEnabled,
    required this.onChanged,
    required this.selectedRole,
  });

  final EmployeeRole selectedRole;
  final ValueChanged<EmployeeRole?> onChanged;
  final bool isEnabled;

  String get _label => switch (selectedRole) {
    .admin => 'Administrador',
    .colaborator => 'Funcionário',
  };

  @override
  Widget build(final BuildContext context) =>
      DropdownButtonFormField<EmployeeRole>(
        initialValue: selectedRole,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.work),
          labelText: 'Função',
        ),
        items: EmployeeRole.values
            .map(
              (final role) =>
                  DropdownMenuItem(value: role, child: Text(_label)),
            )
            .toList(),
        onChanged: isEnabled ? onChanged : null,
        validator: (final value) =>
            value == null ? 'Selecione uma função' : null,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<EmployeeRole>('selectedRole', selectedRole))
      ..add(
        ObjectFlagProperty<ValueChanged<EmployeeRole?>>.has(
          'onChanged',
          onChanged,
        ),
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
      labelText: 'Descricao (Opcional)',
      hintText: 'Adicione informações adicionais',
    ),
    textInputAction: .done,
    textCapitalization: .sentences,
    maxLines: 4,
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
    required this.isEditing,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isEditing;
  final Future<void> Function() onPressed;

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
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(DiagnosticsProperty<bool>('isEditing', isEditing))
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onPressed', onPressed),
      );
  }
}
