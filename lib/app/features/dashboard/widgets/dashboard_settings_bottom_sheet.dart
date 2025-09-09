import 'package:condo_connect/app/data/models/user_preferences.dart';
import 'package:condo_connect/app/features/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';

class DashboardSettingsBottomSheet extends StatelessWidget {
  final DashboardViewModel viewModel;

  const DashboardSettingsBottomSheet({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return SafeArea(
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
        );
      },
    );
  }

  Widget _sheetHeader(BuildContext context) {
    return SizedBox(
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
  }

  Widget _themeSelector(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.palette),
      title: const Text('tema'),
      trailing: DropdownButton<ThemeMode>(
          value: viewModel.themeMode,
          onChanged: (mode) {
            if (mode != null) {
              viewModel.updateThemeMode(mode);
            }
          },
          items: const [
            DropdownMenuItem(value: ThemeMode.system, child: Text('Sistema')),
            DropdownMenuItem(value: ThemeMode.light, child: Text('Claro')),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('Escuro')),
          ]),
    );
  }

  Widget _viewTypeSelector(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.view_module),
      title: Text('Visualização'),
      trailing: DropdownButton<DashboardViewType>(
          value: viewModel.dashboardViewType,
          onChanged: (type) {
            if (type != null) {
              viewModel.updateDashboardViewType(type);
            }
          },
          items: const [
            DropdownMenuItem(
                value: DashboardViewType.grid, child: Text('Grid')),
            DropdownMenuItem(
                value: DashboardViewType.list, child: Text('Lista')),
            DropdownMenuItem(
                value: DashboardViewType.compact, child: Text('Compacto')),
          ]),
    );
  }

  Widget _itemsPerRowSelector(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.grid_3x3),
      title: Text('Itens por linha: ${viewModel.itemsPerRow}'),
      subtitle: Slider(
          value: viewModel.itemsPerRow.toDouble(),
          min: 1,
          max: 4,
          divisions: 3,
          label: viewModel.itemsPerRow.toString(),
          onChanged: (value) => viewModel.updateItemsPerRow(value.round())),
    );
  }

  Widget _languageSelector(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Idioma'),
      trailing: DropdownButton<String>(
          value: viewModel.language,
          onChanged: (lang) => viewModel.updateLanguage(lang!),
          items: const [
            DropdownMenuItem(value: 'pt_BR', child: Text('Português')),
            DropdownMenuItem(value: 'en_US', child: Text('English')),
            DropdownMenuItem(value: 'es_ES', child: Text('Español')),
          ]),
    );
  }

  Widget _showBadgesSwitch(BuildContext context) {
    return SwitchListTile(
        secondary: const Icon(Icons.notifications_active),
        title: const Text('Mostrar badges de notificação'),
        value: viewModel.showNotificationBadges,
        onChanged: viewModel.updateShowNotificationBadges);
  }

  Widget _enableSoundsSwitch(BuildContext context) {
    return SwitchListTile(
        secondary: const Icon(Icons.volume_up),
        title: const Text('Ativar sons'),
        value: viewModel.enableSounds,
        onChanged: viewModel.updateEnableSounds);
  }

  Widget _hiddenItemsSelector(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.visibility_off),
      title: const Text('Itens ocultos'),
      children: [
        ...viewModel.allDashboardItems
            .where((item) => viewModel.isItemHidden(item.route))
            .map((item) => ListTile(
                  leading: Icon(item.icon, color: item.color),
                  title: Text(item.title),
                  trailing: IconButton(
                      onPressed: () => viewModel.showItem(item.route),
                      icon: const Icon(Icons.visibility)),
                )),
        if (viewModel.hiddenItems.isEmpty)
          const ListTile(
            title: Text('Nenhum item oculto'),
          )
      ],
    );
  }

  Widget _actionsRow(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: OutlinedButton.icon(
              onPressed: () => viewModel.resetToDefaultOrder(),
              icon: const Icon(Icons.refresh),
              label: const Text('Restaurar padrão')),
        ),
        Expanded(
            child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check),
                label: const Text('Concluir')))
      ],
    );
  }
}
