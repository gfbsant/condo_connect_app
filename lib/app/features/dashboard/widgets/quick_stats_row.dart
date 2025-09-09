import 'package:condo_connect/app/data/models/permission.dart';
import 'package:condo_connect/app/features/dashboard/model/stat_data.dart';
import 'package:condo_connect/app/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:condo_connect/app/features/dashboard/widgets/stat_card.dart';
import 'package:flutter/material.dart';

class QuickStatsRow extends StatelessWidget {
  final DashboardViewModel viewModel;

  const QuickStatsRow(this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final pendingCounts = viewModel.pendingCounts;
    final stats = <StatData>[];

    int? chamadosCount = pendingCounts['tickets'];
    if (chamadosCount != null) {
      bool canViewAllTickets =
          viewModel.hasPermission(Permission.viewAllTickets);
      stats.add(StatData(
          title: viewModel.hasPermission(Permission.viewAllTickets)
              ? 'Chamados'
              : 'Meus Chamados',
          value: chamadosCount.toString(),
          subtitle: canViewAllTickets ? 'Em aberto' : 'Chamados',
          icon: Icons.support_agent,
          color: Colors.blue));
    }

    int? notificacoesCount = pendingCounts['notifications'];
    if (notificacoesCount != null) {
      stats.add(StatData(
          title: 'Notificações',
          value: notificacoesCount.toString(),
          subtitle: 'Não lidas',
          icon: Icons.notifications,
          color: Colors.orange));
    }

    bool canManageUsers = viewModel.hasPermission(Permission.manageUsers);
    int? usersCount = pendingCounts['users'];
    if (canManageUsers && usersCount != null) {
      stats.add(StatData(
          title: 'Usuários',
          value: usersCount.toString(),
          subtitle: 'Pendentes',
          icon: Icons.people,
          color: Colors.green));
    }

    bool canManageVisitors = viewModel.hasPermission(Permission.manageVisitors);
    int? visitorsCount = pendingCounts['visitors'];
    if (canManageVisitors && visitorsCount != null) {
      stats.add(StatData(
          title: 'Visitantes',
          value: visitorsCount.toString(),
          subtitle: 'Aguardando',
          icon: Icons.badge,
          color: Colors.purple));
    }

    if (stats.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, index) => const SizedBox(width: 12),
          itemCount: stats.length,
          itemBuilder: (_, index) {
            final stat = stats[index];
            return StatCard(
                title: stat.title,
                value: stat.value,
                subtitle: stat.subtitle,
                icon: stat.icon,
                color: stat.color);
          }),
    );
  }
}
