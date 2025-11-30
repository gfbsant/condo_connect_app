import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/resident_entity.dart';
import '../providers/resident_provider.dart';
import '../providers/resident_state.dart';
import 'resident_form_page.dart';

class ResidentDetailPage extends ConsumerStatefulWidget {
  const ResidentDetailPage({
    required this.apartmentId,
    required this.residentId,
    super.key,
  });

  final int apartmentId;
  final int residentId;

  @override
  ConsumerState<ResidentDetailPage> createState() => _ResidentDetailPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('residentId', residentId))
      ..add(IntProperty('apartmentId', apartmentId));
  }
}

class _ResidentDetailPageState extends ConsumerState<ResidentDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadResident();
    });
  }

  Future<void> _loadResident() async {
    await ref
        .read(residentNotifierAccessor)
        .getResidentById(widget.apartmentId, widget.residentId);
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen(
        residentNotifierProvider.select<String?>(
          (final state) => state.errorMessage,
        ),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen<String?>(
        residentNotifierProvider.select((final state) => state.successMessage),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );

    final ResidentState state = ref.watch(residentNotifierProvider);
    final isLoading = state.status == .loading;
    final ResidentEntity? resident = state.selectedResident;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ResidentDetailAppBar(
        resident: resident,
        editCallback: _navigateToEdit,
        deleteCallback: _handleDelete,
      ),
      body: ResidentDetailBody(resident: resident, isLoading: isLoading),
    );
  }

  void _clearMessages() {
    ref.read(residentNotifierAccessor).clearMessages();
  }

  void _showErrorSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: .floating,
      ),
    );
  }

  void _showSuccessSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: .floating,
      ),
    );
  }

  Future<void> _navigateToEdit(final ResidentEntity? resident) async {
    if (resident != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResidentFormPage(
            apartmentId: widget.apartmentId,
            resident: resident,
          ),
        ),
      );
    }
  }

  Future<void> _handleDelete() async {
    final bool? confirmed = await showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir morador?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != null && confirmed) {
      final bool success = await ref
          .read(residentNotifierAccessor)
          .deleteResident(widget.apartmentId, widget.residentId);

      if (success && mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class ResidentDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ResidentDetailAppBar({
    required this.deleteCallback,
    required this.editCallback,
    required this.resident,
    super.key,
  });

  final ResidentEntity? resident;
  final Future<void> Function(ResidentEntity?) editCallback;
  final Future<void> Function() deleteCallback;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Detalhes do Morador'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: resident != null
        ? [
            IconButton(
              onPressed: () async {
                await editCallback(resident);
              },
              icon: const Icon(Icons.edit),
              tooltip: 'Editar',
            ),
            IconButton(
              onPressed: () async {
                await deleteCallback();
              },
              icon: const Icon(Icons.delete),
              tooltip: 'Excluir',
            ),
          ]
        : null,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ResidentEntity?>('resident', resident))
      ..add(
        ObjectFlagProperty<Future<void> Function(ResidentEntity?)>.has(
          'editCallback',
          editCallback,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'deleteCallback',
          deleteCallback,
        ),
      );
  }
}

class ResidentDetailBody extends StatelessWidget {
  const ResidentDetailBody({
    required this.isLoading,
    required this.resident,
    super.key,
  });

  final ResidentEntity? resident;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: isLoading || resident == null
        ? const _LoadingView()
        : SingleChildScrollView(
            padding: const .all(16),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 20,
              children: [
                _ResidentHeader(resident: resident!),
                _ResidentInfo(resident: resident!),
              ],
            ),
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(DiagnosticsProperty<ResidentEntity?>('resident', resident));
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
        Text('Carregando detalhes'),
      ],
    ),
  );
}

class _ResidentHeader extends StatelessWidget {
  const _ResidentHeader({required this.resident});

  final ResidentEntity resident;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const .all(16),
        child: Column(
          spacing: 16,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 60,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            Column(
              spacing: 8,
              children: [
                Text(
                  resident.userName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: .bold,
                  ),
                  textAlign: .center,
                ),
                if (resident.owner)
                  Chip(
                    avatar: const Icon(Icons.star),
                    label: const Text('Proprietário'),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: .bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ResidentEntity>('resident', resident));
  }
}

class _ResidentInfo extends StatelessWidget {
  const _ResidentInfo({required this.resident});

  final ResidentEntity resident;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            Text(
              'Informações do Morador',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
            ),
            _InfoRow(
              icon: Icons.badge,
              label: 'ID',
              value: resident.id.toString(),
            ),
            _InfoRow(
              icon: Icons.person,
              label: 'Nome do Usuário',
              value: resident.userName,
            ),
            _InfoRow(
              icon: resident.owner ? Icons.star : Icons.people,
              label: 'Tipo',
              value: resident.owner ? 'Proprietário' : 'Morador',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ResidentEntity>('resident', resident));
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      spacing: 12,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: .w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('label', label))
      ..add(StringProperty('value', value));
  }
}
