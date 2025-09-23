import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/models/permission.dart';
import '../model/stat_data.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import 'stat_card.dart';

class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow(this.viewModel, {super.key});
  final DashboardViewModel viewModel;

  @override
  Widget build(final BuildContext context) {
    final Map<String, int> pendingCounts = viewModel.pendingCounts;
    final stats = <StatData>[];

    final int? chamadosCount = pendingCounts['tickets'];
    if (chamadosCount != null) {
      final bool canViewAllTickets =
          viewModel.hasPermission(Permission.viewAllTickets);
      stats.add(
        StatData(
          title: viewModel.hasPermission(Permission.viewAllTickets)
              ? 'Chamados'
              : 'Meus Chamados',
          value: chamadosCount.toString(),
          subtitle: canViewAllTickets ? 'Em aberto' : 'Chamados',
          icon: Icons.support_agent,
          color: Colors.blue,
        ),
      );
    }

    final int? notificacoesCount = pendingCounts['notifications'];
    if (notificacoesCount != null) {
      stats.add(
        StatData(
          title: 'Notificações',
          value: notificacoesCount.toString(),
          subtitle: 'Não lidas',
          icon: Icons.notifications,
          color: Colors.orange,
        ),
      );
    }

    final bool canManageUsers = viewModel.hasPermission(Permission.manageUsers);
    final int? usersCount = pendingCounts['users'];
    if (canManageUsers && usersCount != null) {
      stats.add(
        StatData(
          title: 'Usuários',
          value: usersCount.toString(),
          subtitle: 'Pendentes',
          icon: Icons.people,
          color: Colors.green,
        ),
      );
    }

    final bool canManageVisitors =
        viewModel.hasPermission(Permission.manageVisitors);
    final int? visitorsCount = pendingCounts['visitors'];
    if (canManageVisitors && visitorsCount != null) {
      stats.add(
        StatData(
          title: 'Visitantes',
          value: visitorsCount.toString(),
          subtitle: 'Aguardando',
          icon: Icons.badge,
          color: Colors.purple,
        ),
      );
    }

    if (stats.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (final _, final index) => const SizedBox(width: 12),
        itemCount: stats.length,
        itemBuilder: (final _, final index) {
          final StatData stat = stats[index];
          return StatCard(
            title: stat.title,
            value: stat.value,
            subtitle: stat.subtitle,
            icon: stat.icon,
            color: stat.color,
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<DashboardViewModel>('viewModel', viewModel));
  }
}
