import 'package:condo_connect/app/features/dashboard/model/dashboard_item.dart';
import 'package:condo_connect/app/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:condo_connect/app/features/dashboard/widgets/dashboard_item_card.dart';
import 'package:condo_connect/app/features/dashboard/widgets/reorderable_wrap.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardGrid extends StatelessWidget {
  final DashboardViewModel viewModel;

  const DashboardGrid(this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    final items = viewModel.dashboardItems;

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
              )
          ],
        ),
        const SizedBox(height: 16),
        viewModel.isReorderMode
            ? ReorderableWrap(
                spacing: 12,
                runSpacing: 12,
                children: items
                    .map((item) => DashboardItemCard(
                          key: ValueKey(item.route),
                          item: item,
                          onTap: () => _navigateToItem(context, item),
                          isReorderMode: true,
                        ))
                    .toList(),
                onReorder: (oldIndex, newIndex) =>
                    viewModel.reorderItems(oldIndex, newIndex))
            : Wrap(
                spacing: 12,
                runSpacing: 12,
                children: items
                    .map((item) => DashboardItemCard(
                          key: ValueKey(item.route),
                          item: item,
                          onTap: () => _navigateToItem(context, item),
                          isReorderMode: false,
                        ))
                    .toList(),
              ),
      ],
    );
  }

  void _navigateToItem(BuildContext context, DashboardItem item) {
    final viewModel = context.read<DashboardViewModel>();
    viewModel.navigateToItem(item, (route) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navegando para: ${item.title}')),
      );
    });
  }
}
