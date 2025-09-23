import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../data/models/user_preferences.dart';
import '../viewmodel/dashboard_viewmodel.dart';

class DashboardSettingsBottomSheet extends StatelessWidget {
  const DashboardSettingsBottomSheet({required this.viewModel, super.key});
  final DashboardViewModel viewModel;

  @override
  Widget build(final BuildContext context) => ListenableBuilder(
        listenable: viewModel,
        builder: (final context, final child) => SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sheetHeader(context),
                const SizedBox(height: 16),
                _themeSelector(context),
                _viewTypeSelector(context),
                if (viewModel.dashboardViewType == DashboardViewType.grid)
                  _itemsPerRowSelector(context),
                _languageSelector(context),
                _showBadgesSwitch(context),
                _enableSoundsSwitch(context),
                const SizedBox(height: 16),
                _hiddenItemsSelector(context),
                const SizedBox(height: 16),
                _actionsRow(context),
              ],
            ),
          ),
        ),
      );

  Widget _sheetHeader(final BuildContext context) => SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            const Icon(Icons.settings),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Configurações do dashboard',
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  Widget _themeSelector(final BuildContext context) => ListTile(
        leading: const Icon(Icons.palette),
        title: const Text('tema'),
        trailing: DropdownButton<ThemeMode>(
          value: viewModel.themeMode,
          onChanged: (final mode) {
            if (mode != null) {
              viewModel.updateThemeMode(mode);
            }
          },
          items: const [
            DropdownMenuItem(value: ThemeMode.system, child: Text('Sistema')),
            DropdownMenuItem(value: ThemeMode.light, child: Text('Claro')),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('Escuro')),
          ],
        ),
      );

  Widget _viewTypeSelector(final BuildContext context) => ListTile(
        leading: const Icon(Icons.view_module),
        title: const Text('Visualização'),
        trailing: DropdownButton<DashboardViewType>(
          value: viewModel.dashboardViewType,
          onChanged: (final type) {
            if (type != null) {
              viewModel.updateDashboardViewType(type);
            }
          },
          items: const [
            DropdownMenuItem(
              value: DashboardViewType.grid,
              child: Text('Grid'),
            ),
            DropdownMenuItem(
              value: DashboardViewType.list,
              child: Text('Lista'),
            ),
            DropdownMenuItem(
              value: DashboardViewType.compact,
              child: Text('Compacto'),
            ),
          ],
        ),
      );

  Widget _itemsPerRowSelector(final BuildContext context) => ListTile(
        leading: const Icon(Icons.grid_3x3),
        title: Text('Itens por linha: ${viewModel.itemsPerRow}'),
        subtitle: Slider(
          value: viewModel.itemsPerRow.toDouble(),
          min: 1,
          max: 4,
          divisions: 3,
          label: viewModel.itemsPerRow.toString(),
          onChanged: (final value) =>
              viewModel.updateItemsPerRow(value.round()),
        ),
      );

  Widget _languageSelector(final BuildContext context) => ListTile(
        leading: const Icon(Icons.language),
        title: const Text('Idioma'),
        trailing: DropdownButton<String>(
          value: viewModel.language,
          onChanged: (final lang) => viewModel.updateLanguage(lang!),
          items: const [
            DropdownMenuItem(value: 'pt_BR', child: Text('Português')),
            DropdownMenuItem(value: 'en_US', child: Text('English')),
            DropdownMenuItem(value: 'es_ES', child: Text('Español')),
          ],
        ),
      );

  Widget _showBadgesSwitch(final BuildContext context) => SwitchListTile(
        secondary: const Icon(Icons.notifications_active),
        title: const Text('Mostrar badges de notificação'),
        value: viewModel.showNotificationBadges,
        onChanged: viewModel.updateShowNotificationBadges,
      );

  Widget _enableSoundsSwitch(final BuildContext context) => SwitchListTile(
        secondary: const Icon(Icons.volume_up),
        title: const Text('Ativar sons'),
        value: viewModel.enableSounds,
        onChanged: viewModel.updateEnableSounds,
      );

  Widget _hiddenItemsSelector(final BuildContext context) => ExpansionTile(
        leading: const Icon(Icons.visibility_off),
        title: const Text('Itens ocultos'),
        children: [
          ...viewModel.allDashboardItems
              .where((final item) => viewModel.isItemHidden(item.route))
              .map(
                (final item) => ListTile(
                  leading: Icon(item.icon, color: item.color),
                  title: Text(item.title),
                  trailing: IconButton(
                    onPressed: () => viewModel.showItem(item.route),
                    icon: const Icon(Icons.visibility),
                  ),
                ),
              ),
          if (viewModel.hiddenItems.isEmpty)
            const ListTile(
              title: Text('Nenhum item oculto'),
            ),
        ],
      );

  Widget _actionsRow(final BuildContext context) => Row(
        spacing: 8,
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: viewModel.resetToDefaultOrder,
              icon: const Icon(Icons.refresh),
              label: const Text('Restaurar padrão'),
            ),
          ),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check),
              label: const Text('Concluir'),
            ),
          ),
        ],
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<DashboardViewModel>('viewModel', viewModel));
  }
}
