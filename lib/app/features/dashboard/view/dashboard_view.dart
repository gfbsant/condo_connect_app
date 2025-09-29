import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/permission.dart';
import '../../../data/repositories/user_preferences_repository.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import '../widgets/dashboard_grid.dart';
import '../widgets/dashboard_settings_bottom_sheet.dart';
import '../widgets/notification_badge.dart';
import '../widgets/quick_stats_row.dart';
import '../widgets/welcome_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late DashboardViewModel _dashboardViewModel;

  @override
  void initState() {
    super.initState();
    _dashboardViewModel = DashboardViewModel(
      context.read<AuthViewModel>(),
      context.read<UserPreferencesRepository>(),
    );
  }

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider.value(
        value: _dashboardViewModel,
        child: Consumer<DashboardViewModel>(
          builder: (final context, final viewModel, final child) => Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: _buildAppBar(context, viewModel),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: viewModel.refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          kToolbarHeight -
                          32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WelcomeCard(viewModel),
                        const SizedBox(height: 16),
                        QuickStatsRow(viewModel),
                        const SizedBox(height: 16),
                        DashboardGrid(viewModel),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton:
                _buildFloatingActionButton(context, viewModel),
          ),
        ),
      );

  PreferredSizeWidget _buildAppBar(
    final BuildContext context,
    final DashboardViewModel viewModel,
  ) {
    final int? pendingNotifications = viewModel.pendingCounts['notificacoes '];
    return AppBar(
      title: Text('Dashboard - ${viewModel.roleDisplayName}'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        if (pendingNotifications != null && pendingNotifications > 0)
          NotificationBadge(
            count: pendingNotifications,
            onTap: () => _navigateToNotifications(context),
          ),
        IconButton(
          onPressed: () => _showSettingsBottomSheet(context),
          icon: const Icon(Icons.settings),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (final value) =>
              _handleMenuSelection(context, viewModel, value),
          itemBuilder: (final context) => [
            const PopupMenuItem<String>(
              value: 'perfil',
              child: Row(
                spacing: 8,
                children: [
                  Icon(Icons.person),
                  Text('Perfil'),
                ],
              ),
            ),
            if (viewModel.hasPermission(Permission.adminAccess))
              const PopupMenuItem<String>(
                value: 'admin',
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.admin_panel_settings),
                    Text('Administração'),
                  ],
                ),
              ),
            const PopupMenuItem<String>(
              value: 'reorder',
              child: Row(
                spacing: 8,
                children: [
                  Icon(Icons.reorder),
                  Text('Reordenar itens'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                spacing: 8,
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  Text('Sair', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton(
    final BuildContext context,
    final DashboardViewModel viewModel,
  ) {
    if (!viewModel.hasPermission(Permission.createTicket)) {
      return null;
    }

    return FloatingActionButton.extended(
      onPressed: () => _navigateToNewTicket(context),
      icon: const Icon(Icons.add),
      label: const Text('Novo Chamado'),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  Future<void> _showSettingsBottomSheet(final BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (final context) =>
          DashboardSettingsBottomSheet(viewModel: _dashboardViewModel),
    );
  }

  Future<void> _handleMenuSelection(
    final BuildContext context,
    final DashboardViewModel viewModel,
    final String value,
  ) async {
    switch (value) {
      case 'perfil':
        _navigateToProfile(context);
      case 'admin':
        if (viewModel.hasPermission(Permission.adminAccess)) {
          _navigateToAdmin(context);
        }
      case 'reorder':
        viewModel.toggleReorderMode();
      case 'logout':
        await _showLogoutDialog(context, viewModel);
    }
  }

  void _navigateToProfile(final BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Navegando para: Perfil')));
  }

  void _navigateToAdmin(final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando para: Administração')),
    );
  }

  void _navigateToNewTicket(final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando para: Novo Chamado')),
    );
  }

  void _navigateToNotifications(final BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando para: Notificações')),
    );
  }

  Future<void> _showLogoutDialog(
    final BuildContext context,
    final DashboardViewModel viewModel,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await viewModel.logout();
      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  void dispose() {
    _dashboardViewModel.dispose();
    super.dispose();
  }
}
