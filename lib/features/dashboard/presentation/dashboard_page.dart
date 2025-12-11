import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../apartments/presentation/pages/apartment_list_page.dart';
import '../../auth/domain/entities/permission_entity.dart';
import '../../auth/domain/enums/permission_role.dart';
import '../../auth/presentation/providers/auth_notifier.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../../condominium/domain/entities/condominium_entity.dart';
import '../../condominium/presentation/pages/condo_form_page.dart';
import '../../condominium/presentation/pages/condo_search_page.dart';
import '../../condominium/presentation/providers/condo_providers.dart';
import '../../employee/presentation/pages/employee_list_page.dart';
import '../../facilities/presentation/pages/facility_list_page.dart';
import '../../notice/presentation/pages/notice_list_page.dart';

class DashBoardPage extends ConsumerStatefulWidget {
  const DashBoardPage({super.key});

  @override
  ConsumerState<DashBoardPage> createState() => _DashgboardPageState();
}

class _DashgboardPageState extends ConsumerState<DashBoardPage> {
  PermissionEntity? _selectedPermission;

  late final AuthNotifier _authNotifier;

  @override
  void initState() {
    super.initState();
    _authNotifier = ref.read(authNotifierAccessor);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadPermissions();
    });
  }

  Future<void> _loadPermissions() async {
    if (!mounted) {
      return;
    }
    await _authNotifier.getUserPermissions();
    if (!mounted) {
      return;
    }
    final List<PermissionEntity> permissions = ref.read(permissionsProvider);
    if (permissions.isNotEmpty && _selectedPermission == null) {
      setState(() => _selectedPermission = permissions.first);
      await _loadCondominium();
    }
  }

  Future<void> _loadCondominium() async {
    if (!mounted) {
      return;
    }
    if (_selectedPermission != null) {
      await ref
          .read(condoNotifierAccessor)
          .getCondoById(_selectedPermission!.condominiumId);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final List<PermissionEntity> permissions = ref.watch(permissionsProvider);
    final CondominiumEntity? selectedCondo = ref.watch(selectedCondoProvider);
    final bool isLoadingPermissions = ref.watch(isLoadingPermissionsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: DashboardAppBar(
        condoName: selectedCondo?.name,
        permissions: permissions,
        selectedPermission: _selectedPermission,
        onPermissionChanged: _changePermission,
        onLogout: _handleLogout,
      ),
      body: DashboardBody(
        permissions: permissions,
        condominium: selectedCondo,
        selectedPermission: _selectedPermission,
        isLoadingPermissions: isLoadingPermissions,
        createCondoCallback: _navigateToCreateCondo,
        searchCondoCallback: _navigateToSearchCondo,
      ),
    );
  }

  Future<void> _changePermission(final PermissionEntity? permission) async {
    setState(() => _selectedPermission = permission);
    await _loadCondominium();
  }

  Future<void> _navigateToCreateCondo() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CondoFormPage()));
    await _loadPermissions();
  }

  Future<void> _navigateToSearchCondo() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CondoSearchPage()));
  }

  Future<void> _handleLogout() async {
    await _authNotifier.logout();
    if (!mounted) {
      return;
    }
  }
}

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({
    required this.condoName,
    required this.permissions,
    required this.selectedPermission,
    required this.onPermissionChanged,
    required this.onLogout,
    super.key,
  });

  final String? condoName;
  final List<PermissionEntity> permissions;
  final PermissionEntity? selectedPermission;
  final Future<void> Function(PermissionEntity?) onPermissionChanged;
  final Future<void> Function() onLogout;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.primaryContainer,
      elevation: 0,
      title: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'Dashboard',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: .bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          if (condoName != null)
            Text(
              condoName!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withAlpha(200),
              ),
            ),
        ],
      ),
      actions: [
        if (permissions.length > 1)
          _PermissionSelector(
            permissions: permissions,
            selectedPermission: selectedPermission,
            onChanged: onPermissionChanged,
          ),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Sair',
          onPressed: onLogout,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('condoName', condoName))
      ..add(IterableProperty<PermissionEntity>('permissions', permissions))
      ..add(
        DiagnosticsProperty<PermissionEntity?>(
          'selectedPermission',
          selectedPermission,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function(PermissionEntity?)>.has(
          'onPermissionChanged',
          onPermissionChanged,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onLogout', onLogout),
      );
  }
}

class DashboardBody extends StatelessWidget {
  const DashboardBody({
    required this.permissions,
    required this.condominium,
    required this.isLoadingPermissions,
    required this.createCondoCallback,
    required this.searchCondoCallback,
    required this.selectedPermission,
    super.key,
  });

  final List<PermissionEntity> permissions;
  final PermissionEntity? selectedPermission;
  final CondominiumEntity? condominium;
  final Future<void> Function() createCondoCallback;
  final Future<void> Function() searchCondoCallback;
  final bool isLoadingPermissions;

  @override
  Widget build(final BuildContext context) {
    if (isLoadingPermissions ||
        (permissions.isNotEmpty && condominium == null)) {
      return const _LoadingView();
    }

    if (permissions.isEmpty) {
      return const _NoPermissionsView();
    }
    return SafeArea(
      child: SingleChildScrollView(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 24,
          children: [
            _RoleCard(role: selectedPermission!.role),
            if (condominium != null)
              _MenuSection(
                condominium: condominium!,
                permission: selectedPermission!,
              ),
            _CondoManagementSection(
              createCondoCallback: createCondoCallback,
              searchCondoCallback: searchCondoCallback,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<CondominiumEntity?>('condominium', condominium))
      ..add(
        DiagnosticsProperty<PermissionEntity?>(
          'permission',
          selectedPermission,
        ),
      )
      ..add(
        DiagnosticsProperty<bool>('isLoadingPermissions', isLoadingPermissions),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'createCondoCallback',
          createCondoCallback,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'searchCondoCallback',
          searchCondoCallback,
        ),
      )
      ..add(IterableProperty<PermissionEntity>('permissions', permissions));
  }
}

class _PermissionSelector extends StatelessWidget {
  const _PermissionSelector({
    required this.permissions,
    required this.selectedPermission,
    required this.onChanged,
  });

  final List<PermissionEntity> permissions;
  final PermissionEntity? selectedPermission;
  final Future<void> Function(PermissionEntity?) onChanged;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PopupMenuButton<PermissionEntity>(
      icon: Icon(Icons.swap_horiz, color: theme.colorScheme.onPrimaryContainer),
      tooltip: 'Trocar Condomínio',
      onSelected: (final permission) async {
        await onChanged(permission);
      },
      itemBuilder: (final context) => permissions
          .map(
            (final permission) => PopupMenuItem<PermissionEntity>(
              value: permission,
              child: Row(
                spacing: 12,
                children: [
                  Icon(
                    selectedPermission?.condominiumId ==
                            permission.condominiumId
                        ? Icons.check_circle
                        : Icons.apartment,
                    color:
                        selectedPermission?.condominiumId ==
                            permission.condominiumId
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          'Condomínio ${permission.condominiumId}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                        Text(_getRoleLabel(permission.role)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  String _getRoleLabel(final PermissionRole role) => switch (role) {
    .admin => 'Administrador',
    .collaborator => 'Colaborador',
    .owner => 'Proprietário',
    .resident => 'Morador',
  };

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<PermissionEntity>('permissions', permissions))
      ..add(
        DiagnosticsProperty<PermissionEntity?>(
          'selectedPermission',
          selectedPermission,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function(PermissionEntity?)>.has(
          'onChanged',
          onChanged,
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
        Text('Carregando dashboard'),
      ],
    ),
  );
}

class _NoPermissionsView extends StatelessWidget {
  const _NoPermissionsView();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const .all(24),
          child: Column(
            mainAxisAlignment: .center,
            spacing: 32,
            children: [
              Icon(
                Icons.apartment_outlined,
                size: 80,
                color: theme.colorScheme.primary.withAlpha(153),
              ),
              Column(
                spacing: 8,
                children: [
                  Text(
                    'Nenhum Condomínio Vinculado',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: .bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: .center,
                  ),
                  Text(
                    'Você ainda não está vinculado a nengum condomínio\n'
                    'Escolha uma das opções abaixo para começar:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: .center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(12),
        child: Container(
          padding: const .all(20),
          decoration: BoxDecoration(
            borderRadius: .circular(12),
            border: .all(color: color.withAlpha(77), width: 2),
          ),
          child: Row(
            spacing: 16,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withAlpha(51),
                child: Icon(icon, size: 32, color: color),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 4,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: .bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: color),
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
      ..add(StringProperty('title', title))
      ..add(StringProperty('description', description))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(ColorProperty('color', color))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.role});

  final PermissionRole role;

  String get _roleLabel => switch (role) {
    .admin => 'Administrador',
    .collaborator => 'Colaborador',
    .owner => 'Proprietário',
    .resident => 'Morador',
  };

  IconData get _roleIcon => switch (role) {
    .admin => Icons.admin_panel_settings,
    .collaborator => Icons.work,
    .owner => Icons.star,
    .resident => Icons.person_outline,
  };

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const .all(16),
        child: Row(
          spacing: 12,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                _roleIcon,
                color: theme.colorScheme.onPrimaryContainer,
                size: 28,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Seu Perfil',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _roleLabel,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<PermissionRole>('role', role));
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.condominium, required this.permission});

  final PermissionEntity permission;
  final CondominiumEntity condominium;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Widget> menuItems = _buildMenuItems(context);
    return Column(
      crossAxisAlignment: .start,
      spacing: 16,
      children: [
        Text(
          'Menu',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: .bold),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: menuItems,
        ),
      ],
    );
  }

  List<Widget> _buildMenuItems(final BuildContext context) {
    final int? condominiumId = condominium.id;
    final items = <Widget>[];
    if (condominiumId != null) {
      if (permission.hasPermission(.readApartment)) {
        items.add(
          _DashboardMenuCard(
            title: 'Apartamentos',
            icon: Icons.apartment,
            color: Colors.blue,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ApartmentListPage(condominiumId: condominiumId),
                ),
              );
            },
          ),
        );
      }

      if (permission.hasPermission(.readCondominium)) {
        items.add(
          _DashboardMenuCard(
            title: 'Áreas Comuns',
            icon: Icons.meeting_room,
            color: Colors.green,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FacilityListPage(
                    condominiumId: condominiumId,
                    createAllowed: permission.role == .admin,
                  ),
                ),
              );
            },
          ),
        );
      }

      if (permission.hasPermission(.readNotices) ||
          permission.hasPermission(.readNotice)) {
        items.add(
          _DashboardMenuCard(
            title: 'Avisos',
            icon: Icons.notifications,
            color: Colors.red,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoticeListPage(condoId: condominiumId),
                ),
              );
            },
          ),
        );
      }

      if (permission.role == .admin &&
          permission.hasPermission(.readEmployees)) {
        items.add(
          _DashboardMenuCard(
            title: 'Funcionários',
            icon: Icons.people,
            color: Colors.purple,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      EmployeeListPage(condominiumId: condominiumId),
                ),
              );
            },
          ),
        );
      }
    }

    return items;
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<PermissionEntity>('permission', permission))
      ..add(DiagnosticsProperty<CondominiumEntity>('condominium', condominium));
  }
}

class _DashboardMenuCard extends StatelessWidget {
  const _DashboardMenuCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(12),
        child: Container(
          padding: const .all(16),
          decoration: BoxDecoration(
            borderRadius: .circular(12),
            gradient: LinearGradient(
              begin: .topLeft,
              end: .bottomRight,
              colors: [color.withAlpha(51), color.withAlpha(26)],
            ),
          ),
          child: Column(
            mainAxisAlignment: .center,
            spacing: 12,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withAlpha(77),
                child: Icon(icon, size: 32, color: color),
              ),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: .bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: .center,
                maxLines: 2,
                overflow: .ellipsis,
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
      ..add(StringProperty('title', title))
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(ColorProperty('color', color))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}

class _CondoManagementSection extends StatelessWidget {
  const _CondoManagementSection({
    required this.createCondoCallback,
    required this.searchCondoCallback,
  });

  final Future<void> Function() createCondoCallback;
  final Future<void> Function() searchCondoCallback;

  @override
  Widget build(final BuildContext context) => Padding(
    padding: const EdgeInsets.all(4),
    child: Column(
      spacing: 16,
      children: [
        _ActionCard(
          title: 'Criar Novo Condominio',
          description: 'Cadastre um novo condomínio e se torne administrador',
          icon: Icons.add_business,
          color: Colors.blue,
          onTap: () async {
            await createCondoCallback();
          },
        ),
        _ActionCard(
          title: 'Buscar Condomínio',
          description: 'Encontre e solicite acesso a um condomínio existente',
          icon: Icons.search,
          color: Colors.green,
          onTap: () async {
            await searchCondoCallback();
          },
        ),
      ],
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'createCondoCallback',
          createCondoCallback,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'searchCondoCallback',
          searchCondoCallback,
        ),
      );
  }
}
