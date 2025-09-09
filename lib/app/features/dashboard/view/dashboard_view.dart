import 'package:condo_connect/app/data/models/permission.dart';
import 'package:condo_connect/app/data/repositories/user_preferences_repository_impl.dart';
import 'package:condo_connect/app/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:condo_connect/app/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:condo_connect/app/features/dashboard/widgets/dashboard_grid.dart';
import 'package:condo_connect/app/features/dashboard/widgets/dashboard_settings_bottom_sheet.dart';
import 'package:condo_connect/app/features/dashboard/widgets/notification_badge.dart';
import 'package:condo_connect/app/features/dashboard/widgets/quick_stats_row.dart';
import 'package:condo_connect/app/features/dashboard/widgets/welcome_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _dashboardViewModel,
      child: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: _buildAppBar(context, viewModel),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await viewModel.refresh();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
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
            floatingActionButton:
                _buildFloatingActionButton(context, viewModel),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, DashboardViewModel viewModel) {
    int? pendingNotifications = viewModel.pendingCounts['notificacoes '];
    return AppBar(
      title: Text('Dashboard - ${viewModel.roleDisplayName}'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        if (pendingNotifications != null && pendingNotifications > 0)
          NotificationBadge(
              count: pendingNotifications,
              onTap: () => _navigateToNotifications(context)),
        IconButton(
            onPressed: () => _showSettingsBottomSheet(context),
            icon: Icon(Icons.settings)),
        PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) =>
                _handleMenuSelection(context, viewModel, value),
            itemBuilder: (context) => [
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
                        )),
                  const PopupMenuItem<String>(
                      value: 'reorder',
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.reorder),
                          Text('Reordenar itens')
                        ],
                      )),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          Text('Sair', style: TextStyle(color: Colors.red))
                        ],
                      )),
                ]),
      ],
    );
  }

  Widget? _buildFloatingActionButton(
      BuildContext context, DashboardViewModel viewModel) {
    if (!viewModel.hasPermission(Permission.createTicket)) return null;

    return FloatingActionButton.extended(
      onPressed: () => _navigateToNewTicket(context),
      icon: const Icon(Icons.add),
      label: const Text('Novo Chamado'),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          DashboardSettingsBottomSheet(viewModel: _dashboardViewModel),
    );
  }

  void _handleMenuSelection(
      BuildContext context, DashboardViewModel viewModel, String value) async {
    switch (value) {
      case 'perfil':
        _navigateToProfile(context);
        break;
      case 'admin':
        if (viewModel.hasPermission(Permission.adminAccess)) {
          _navigateToAdmin(context);
        }
        break;
      case 'reorder':
        viewModel.toggleReorderMode();
        break;
      case 'logout':
        _showLogoutDialog(context, viewModel);
        break;
    }
  }

  void _navigateToProfile(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Navegando para: Perfil')));
  }

  void _navigateToAdmin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Navegando para: Administração')));
  }

  void _navigateToNewTicket(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Navegando para: Novo Chamado')));
  }

  void _navigateToNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Navegando para: Notificações')));
  }

  Future<void> _showLogoutDialog(
      BuildContext context, DashboardViewModel viewModel) async {
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Confirmar Logout'),
              content: const Text('Tem certeza que deseja sair?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Sair'))
              ],
            ));
    if (confirmed == true) {
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
