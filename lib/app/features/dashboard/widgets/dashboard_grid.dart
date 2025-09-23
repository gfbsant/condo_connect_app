import 'package:flutter/foundation.dart';

import '../model/dashboard_item.dart';
import '../viewmodel/dashboard_viewmodel.dart';
import 'dashboard_item_card.dart';
import 'reorderable_wrap.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardGrid extends StatelessWidget {
  const DashboardGrid(this.viewModel, {super.key});
  final DashboardViewModel viewModel;

  @override
  Widget build(final BuildContext context) {
    final List<DashboardItem> items = viewModel.dashboardItems;

    if (items.isEmpty) {
      return const Center(child: Text('Nenhuma funcionalidade disponivel'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Funcionalidades',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            if (viewModel.isReorderMode)
              TextButton(
                onPressed: viewModel.exitReorderMode,
                child: const Text('Concluir'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (viewModel.isReorderMode)
          ReorderableWrap(
            spacing: 12,
            runSpacing: 12,
            onReorder: viewModel.reorderItems,
            children: items
                .map(
                  (final item) => DashboardItemCard(
                    key: ValueKey(item.route),
                    item: item,
                    onTap: () => _navigateToItem(context, item),
                    isReorderMode: true,
                  ),
                )
                .toList(),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items
                .map(
                  (final item) => DashboardItemCard(
                    key: ValueKey(item.route),
                    item: item,
                    onTap: () => _navigateToItem(context, item),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  void _navigateToItem(final BuildContext context, final DashboardItem item) {
    final DashboardViewModel viewModel = context.read<DashboardViewModel>();
    viewModel.navigateToItem(item, (final route) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navegando para: ${item.title}')),
      );
    });
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<DashboardViewModel>('viewModel', viewModel));
  }
}
