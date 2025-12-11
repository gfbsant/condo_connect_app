import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/employee_entity.dart';
import '../../domain/enums/employee_role.dart';
import '../providers/employee_providers.dart';
import '../providers/employee_state.dart';
import 'employee_form_page.dart';

class EmployeeDetailPage extends ConsumerStatefulWidget {
  const EmployeeDetailPage({required this.employeeId, super.key});

  final int employeeId;

  @override
  ConsumerState<EmployeeDetailPage> createState() => _EmployeeDetailPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('employeeId', employeeId));
  }
}

class _EmployeeDetailPageState extends ConsumerState<EmployeeDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(employeeNotifierAccessor)
          .getEmployeeBydId(widget.employeeId);
    });
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen(
        employeeNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen(
        employeeNotifierProvider.select((final state) => state.successMessage),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );

    final EmployeeState state = ref.watch(employeeNotifierProvider);
    final isLoading = state.status == .loading;
    final EmployeeEntity? employee = state.selectedEmployee;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: EmployeeDetailAppBar(
        employee: employee,
        editCallback: _navigateToEdit,
        deleteCallback: _handleDelete,
      ),
      body: EmployeeDetailBody(isLoading: isLoading, employee: employee),
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
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: .floating,
      ),
    );
  }

  Future<void> _navigateToEdit(final EmployeeEntity? employee) async {
    if (employee != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EmployeeFormPage(
            condominiumId: employee.condominiumId,
            employee: employee,
          ),
        ),
      );
    }
  }

  Future<void> _handleDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este funcionário?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != null && confirmed && mounted) {
      final bool success = await ref
          .read(employeeNotifierAccessor)
          .deleteEmployee(widget.employeeId);

      if (success && mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class EmployeeDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EmployeeDetailAppBar({
    required this.employee,
    required this.editCallback,
    required this.deleteCallback,
    super.key,
  });

  final EmployeeEntity? employee;
  final Future<void> Function(EmployeeEntity? entity) editCallback;
  final Future<void> Function() deleteCallback;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Detalhes do Funcionário'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: employee != null
        ? [
            IconButton(
              onPressed: () async {
                await editCallback(employee);
              },
              icon: const Icon(Icons.edit, size: 20),
            ),
            IconButton(
              onPressed: () async {
                await deleteCallback();
              },
              icon: const Icon(Icons.delete, size: 20),
            ),
          ]
        : null,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<EmployeeEntity?>('employee', employee))
      ..add(
        ObjectFlagProperty<VoidCallback>.has('deleteCallback', deleteCallback),
      )
      ..add(
        ObjectFlagProperty<void Function(EmployeeEntity)>.has(
          'editCallback',
          editCallback,
        ),
      );
  }
}

class EmployeeDetailBody extends StatelessWidget {
  const EmployeeDetailBody({
    required this.employee,
    required this.isLoading,
    super.key,
  });

  final EmployeeEntity? employee;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: isLoading || employee == null
        ? const _LoadingView()
        : SingleChildScrollView(
            padding: const .all(16),
            child: Column(
              spacing: 20,
              children: [
                _EmployeeHeader(employee: employee!),
                _EmployeeMetadata(employee: employee!),
              ],
            ),
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<EmployeeEntity?>('employee', employee))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading));
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(final BuildContext context) => const Center(
    child: Column(
      mainAxisAlignment: .center,
      spacing: 16,
      children: [
        CircularProgressIndicator.adaptive(),
        Text('Carregando detalhes...'),
      ],
    ),
  );
}

class _EmployeeHeader extends StatelessWidget {
  const _EmployeeHeader({required this.employee});

  final EmployeeEntity employee;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 48,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            Column(
              spacing: 8,
              children: [
                Text(
                  employee.user?.name ?? 'Usuário #${employee.userId}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: .bold,
                  ),
                  textAlign: .center,
                ),
                if (employee.user?.email != null)
                  Text(
                    employee.user!.email!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                _RoleChip(role: employee.role),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EmployeeEntity>('employee', employee));
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role});

  final EmployeeRole role;

  bool get _isAdmin => role == .admin;

  String get _label => switch (role) {
    .admin => 'Administrador',
    .collaborator => 'Funcionário',
  };

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Chip(
      avatar: Icon(_isAdmin ? Icons.admin_panel_settings : Icons.work),
      label: Text(_label),
      backgroundColor: _isAdmin
          ? theme.colorScheme.errorContainer
          : theme.colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: _isAdmin
            ? theme.colorScheme.onErrorContainer
            : theme.colorScheme.onSecondaryContainer,
        fontWeight: .w500,
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<EmployeeRole>('role', role));
  }
}

class _EmployeeMetadata extends StatelessWidget {
  const _EmployeeMetadata({required this.employee});

  final EmployeeEntity employee;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            Text(
              'Informações',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
            ),
            _InfoRow(
              icon: Icons.apartment,
              label: 'ID do Condominio',
              value: employee.condominiumId.toString(),
            ),
            if (employee.user?.phone != null)
              _InfoRow(
                icon: Icons.phone,
                label: 'Telefone',
                value: employee.user!.phone!,
              ),
            if (employee.createdAt != null)
              _InfoRow(
                icon: Icons.calendar_today,
                label: 'Cadastrado em',
                value: dateFormat.format(employee.createdAt!),
              ),
            if (employee.updatedAt != null)
              _InfoRow(
                icon: Icons.update,
                label: 'Atualizado em',
                value: dateFormat.format(employee.updatedAt!),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EmployeeEntity>('employee', employee));
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      spacing: 12,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: .w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('label', label))
      ..add(StringProperty('value', value));
  }
}
