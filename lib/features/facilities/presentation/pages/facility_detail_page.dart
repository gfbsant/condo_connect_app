import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/facility_entity.dart';
import '../providers/facility_providers.dart';
import '../providers/facility_state.dart';
import 'facility_form_page.dart';

class FacilityDetailPage extends ConsumerStatefulWidget {
  const FacilityDetailPage({
    required this.condominiumId,
    required this.facilityId,
    super.key,
  });

  final int facilityId;
  final int condominiumId;

  @override
  ConsumerState<FacilityDetailPage> createState() => _FacilityDetailPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('facilityId', facilityId))
      ..add(IntProperty('condominiumId', condominiumId));
  }
}

class _FacilityDetailPageState extends ConsumerState<FacilityDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadFacility();
    });
  }

  Future<void> _loadFacility() async {
    await ref.read(facilityNotifierAccessor).getFacilityById(widget.facilityId);
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen<String?>(
        facilityNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen<String?>(
        facilityNotifierProvider.select((final state) => state.successMessage),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );

    final FacilityState state = ref.watch(facilityNotifierProvider);
    final isLoading = state.status == .loading;
    final FacilityEntity? facility = state.selectedFacility;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: FacilityDetailAppBar(
        facility: facility,
        editCallback: _navigateToEdit,
        deleteCallback: _handleDelete,
      ),
      body: FacilityDetailBody(
        facility: facility,
        isLoading: isLoading,
        onRefresh: _loadFacility,
      ),
    );
  }

  void _clearMessages() {
    ref.read(facilityNotifierAccessor).clearMessages();
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
          spacing: 8,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: .floating,
      ),
    );
  }

  Future<void> _navigateToEdit(final FacilityEntity? facility) async {
    if (facility != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FacilityFormPage(
            condominiumId: widget.condominiumId,
            facility: facility,
          ),
        ),
      );
    }
  }

  Future<void> _handleDelete() async {
    final bool? confirmed = await showDialog<bool?>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir esta área comum?'),
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
          .read(facilityNotifierAccessor)
          .deleteFacility(widget.facilityId);

      if (success && mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class FacilityDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FacilityDetailAppBar({
    required this.facility,
    required this.editCallback,
    required this.deleteCallback,
    super.key,
  });

  final FacilityEntity? facility;
  final Future<void> Function(FacilityEntity?) editCallback;
  final Future<void> Function() deleteCallback;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Detalhes da Área Comum'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: facility != null
        ? [
            IconButton(
              onPressed: () async {
                await editCallback(facility);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () async {
                await deleteCallback();
              },
              icon: const Icon(Icons.delete),
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
      ..add(DiagnosticsProperty<FacilityEntity?>('facility', facility))
      ..add(
        ObjectFlagProperty<Future<void> Function(FacilityEntity?)>.has(
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

class FacilityDetailBody extends StatelessWidget {
  const FacilityDetailBody({
    required this.facility,
    required this.isLoading,
    required this.onRefresh,
    super.key,
  });

  final FacilityEntity? facility;
  final Future<void> Function() onRefresh;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: isLoading || facility == null
        ? const _LoadingView()
        : SingleChildScrollView(
            padding: const .all(16),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 20,
              children: [
                _FacilityHeader(facility: facility!),
                _FacilityInfo(facility: facility!),
              ],
            ),
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<FacilityEntity?>('facility', facility))
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onRefresh', onRefresh),
      )
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading));
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
        Text('Carregando detalhes...'),
      ],
    ),
  );
}

class _FacilityHeader extends StatelessWidget {
  const _FacilityHeader({required this.facility});

  final FacilityEntity facility;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: r'R$',
    );

    return Card(
      child: Padding(
        padding: const .all(16),
        child: Column(
          spacing: 16,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.meeting_room,
                size: 48,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            Column(
              spacing: 8,
              children: [
                Text(
                  facility.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: .bold,
                  ),
                  textAlign: .center,
                ),
                if (facility.tax != null)
                  Chip(
                    avatar: const Icon(Icons.attach_money),
                    label: Text(
                      'Taxa ${currencyFormat.format(facility.tax! / 100)}',
                    ),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: .w500,
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
    properties.add(DiagnosticsProperty<FacilityEntity>('facility', facility));
  }
}

class _FacilityInfo extends StatelessWidget {
  const _FacilityInfo({required this.facility});

  final FacilityEntity facility;

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
              'Informações',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
            ),
            if (facility.description != null &&
                facility.description!.isNotEmpty)
              _InfoRow(
                icon: Icons.description,
                label: 'Descrição',
                value: facility.description!,
              ),
            if (facility.id != null)
              _InfoRow(
                icon: Icons.tag,
                label: 'ID',
                value: facility.id.toString(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FacilityEntity>('facility', facility));
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
