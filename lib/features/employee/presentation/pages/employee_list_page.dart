import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/employee_entity.dart';
import '../../domain/enums/employee_role.dart';
import '../providers/employee_providers.dart';
import '../providers/employee_state.dart';
import 'employee_detail_page.dart';
import 'employee_form_page.dart';

class EmployeeListPage extends ConsumerStatefulWidget {
  const EmployeeListPage({required this.condominiumId, super.key});

  final int condominiumId;

  @override
  ConsumerState<EmployeeListPage> createState() => _EmployeeListPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('condominiumId', condominiumId));
  }
}

class _EmployeeListPageState extends ConsumerState<EmployeeListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadEmployees();
    });
  }

  Future<void> _loadEmployees() async {
    await ref
        .read(employeeNotifierAccessor)
        .getEmployeesByCondo(widget.condominiumId);
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
    final isSearching = state.status == .searching;
    final List<EmployeeEntity> employees = state.employees;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: EmployeeListAppBar(createCallback: _navigateToCreate),
      body: EmployeeListBody(
        employees: employees,
        isSearching: isSearching,
        detailsCallback: _navigateToDetail,
        refreshCallback: _loadEmployees,
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
        behavior: SnackBarBehavior.floating,
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
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _navigateToCreate() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmployeeFormPage(condominiumId: widget.condominiumId),
      ),
    );
  }

  Future<void> _navigateToDetail(final int employeeId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmployeeDetailPage(employeeId: employeeId),
      ),
    );
  }
}

class EmployeeListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EmployeeListAppBar({required this.createCallback, super.key});

  final VoidCallback createCallback;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Funcionários'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        onPressed: createCallback,
        icon: const Icon(Icons.person_add, size: 20),
        tooltip: 'Adicionar Funcionário',
      ),
    ],
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<VoidCallback>.has('createCallback', createCallback),
    );
  }
}

class EmployeeListBody extends StatelessWidget {
  const EmployeeListBody({
    required this.employees,
    required this.isSearching,
    required this.detailsCallback,
    required this.refreshCallback,
    super.key,
  });

  final List<EmployeeEntity> employees;
  final bool isSearching;
  final void Function(int) detailsCallback;
  final Future<void> Function() refreshCallback;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: isSearching
        ? const _LoadingView()
        : employees.isEmpty
        ? const _EmptyView()
        : _EmployeeList(
            employees: employees,
            onTap: detailsCallback,
            onRefresh: refreshCallback,
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<EmployeeEntity>('employees', employees))
      ..add(
        ObjectFlagProperty<void Function(int)>.has(
          'detailsCallback',
          detailsCallback,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isSearching', isSearching))
      ..add(
        ObjectFlagProperty<VoidCallback>.has(
          'refreshCallback',
          refreshCallback,
        ),
      );
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
        Text('Carregando funcionários...'),
      ],
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        spacing: 16,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant.withAlpha(128),
          ),
          Text(
            'Nenhum funcionario cadastrado',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione funcionarios ao condominio',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeList extends StatelessWidget {
  const _EmployeeList({
    required this.employees,
    required this.onTap,
    required this.onRefresh,
  });

  final List<EmployeeEntity> employees;
  final void Function(int) onTap;
  final Future<void> Function() onRefresh;

  @override
  Widget build(final BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: employees.length,
      itemBuilder: (_, final index) => _EmployeeCard(
        employee: employees[index],
        onTap: () {
          final int? id = employees[index].id;
          if (id != null) {
            onTap(id);
          }
        },
      ),
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<EmployeeEntity>('employees', employees))
      ..add(ObjectFlagProperty<void Function(int)>.has('onTap', onTap))
      ..add(ObjectFlagProperty<VoidCallback>.has('onRefresh', onRefresh));
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({required this.employee, required this.onTap});

  final EmployeeEntity employee;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(12),
        child: Padding(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .start,
            spacing: 12,
            children: [
              Row(
                spacing: 12,
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          employee.user?.name ??
                              'Usuário ID ${employee.userId}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                        if (employee.user?.email != null)
                          Text(
                            employee.user!.email!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 8,
                children: [
                  _RoleChip(role: employee.role),
                  if (employee.createdAt != null)
                    Chip(
                      avatar: const Icon(Icons.calendar_today, size: 16),
                      label: Text(
                        'Desde ${dateFormat.format(employee.createdAt!)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<EmployeeEntity>('employee', employee))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
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
      avatar: Icon(
        _isAdmin ? Icons.admin_panel_settings : Icons.work,
        size: 18,
      ),
      label: Text(_label),
      backgroundColor: _isAdmin
          ? theme.colorScheme.errorContainer
          : theme.colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: _isAdmin
            ? theme.colorScheme.onErrorContainer
            : theme.colorScheme.onSecondaryContainer,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<EmployeeRole>('role', role));
  }
}
