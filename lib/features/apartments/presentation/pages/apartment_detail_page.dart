import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../residents/domain/entities/resident_entity.dart';
import '../../domain/entities/apartment_entity.dart';
import '../providers/apartment_providers.dart';
import '../providers/apartment_state.dart';
import 'apartment_form_page.dart';

class ApartmentDetailPage extends ConsumerStatefulWidget {
  const ApartmentDetailPage({required this.apartmentId, super.key});

  final int apartmentId;

  @override
  ConsumerState<ApartmentDetailPage> createState() =>
      _ApartmentDetailPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('apartmentId', apartmentId));
  }
}

class _ApartmentDetailPageState extends ConsumerState<ApartmentDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(apartmentNotifierAccessor)
          .getApartmentById(widget.apartmentId);
    });
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen(
        apartmentNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen(
        apartmentNotifierProvider.select((final state) => state.successMessage),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );

    final ApartmentState state = ref.watch(apartmentNotifierProvider);
    final isLoading = state.status == .loading;
    final isApproving = state.status == .approving;
    final ApartmentEntity? selectedApartment = state.selectedApartment;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ApartmentDetailAppBar(
        apartment: selectedApartment,
        approveCallback: _handleApprove,
        deleteCallback: _handleDelete,
        editCallback: _navigateToEdit,
        isApproving: isApproving,
      ),
      body: ApartmentDetailBody(
        apartment: selectedApartment,
        isLoading: isLoading,
      ),
    );
  }

  void _clearMessages() {
    ref.read(apartmentNotifierAccessor).clearMessages();
  }

  void _showSuccessSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: .floating,
      ),
    );
  }

  void _showErrorSnackBar(final String message) {
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

  Future<void> _navigateToEdit(final ApartmentEntity? apartment) async {
    if (apartment != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ApartmentFormPage(
            condominiumId: apartment.condominiumId,
            apartment: apartment,
          ),
        ),
      );
    }
  }

  Future<void> _handleApprove() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Confirmar Aprovação'),
        content: const Text('Tem certeza que deseja aprovar este apartamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text('Aprovar'),
          ),
        ],
      ),
    );

    if (confirmed != null && confirmed && mounted) {
      await ref
          .read(apartmentNotifierAccessor)
          .approveApartment(widget.apartmentId);
    }
  }

  Future<void> _handleDelete() async {
    final bool? confirmed = await showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este apartamento?'),
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
          .read(apartmentNotifierAccessor)
          .deleteApartment(widget.apartmentId);

      if (success && mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class ApartmentDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ApartmentDetailAppBar({
    required this.approveCallback,
    required this.deleteCallback,
    required this.editCallback,
    required this.isApproving,
    required this.apartment,
    super.key,
  });

  final ApartmentEntity? apartment;
  final Future<void> Function(ApartmentEntity?) editCallback;
  final Future<void> Function() deleteCallback;
  final Future<void> Function() approveCallback;
  final bool isApproving;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Detalhes do Apartamento'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: apartment != null
        ? [
            if (apartment!.active != true)
              IconButton(
                onPressed: isApproving ? null : approveCallback,
                icon: isApproving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle),
              ),
            IconButton(
              onPressed: () async {
                await editCallback(apartment);
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
      ..add(DiagnosticsProperty<ApartmentEntity?>('apartment', apartment))
      ..add(
        ObjectFlagProperty<Future<void> Function(ApartmentEntity?)>.has(
          'editCallback',
          editCallback,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'deleteCallback',
          deleteCallback,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'approveCallback',
          approveCallback,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isApproving', isApproving));
  }
}

class ApartmentDetailBody extends StatelessWidget {
  const ApartmentDetailBody({
    required this.apartment,
    required this.isLoading,
    super.key,
  });

  final ApartmentEntity? apartment;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: isLoading || apartment == null
        ? const _LoadingView()
        : SingleChildScrollView(
            padding: const .all(16),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 20,
              children: [
                _ApartmentHeader(apartment!),
                _ApartmentInfo(apartment: apartment!),
                if (apartment!.residents != null &&
                    apartment!.residents!.isNotEmpty)
                  _ResidentsList(residents: apartment!.residents!),
                _ApartmentMetadata(apartment: apartment!),
              ],
            ),
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ApartmentEntity?>('apartment', apartment))
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
        Text('Carregando Detalhes'),
      ],
    ),
  );
}

class _ApartmentHeader extends StatelessWidget {
  const _ApartmentHeader(this.apartment);

  final ApartmentEntity apartment;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const .all(16),
        child: Column(
          spacing: 16,
          children: [
            Column(
              spacing: 16,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.apartment,
                    size: 48,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Column(
                  spacing: 8,
                  children: [
                    Text(
                      'Apartamento ${apartment.number}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: .bold,
                      ),
                      textAlign: .center,
                    ),
                    Row(
                      mainAxisAlignment: .center,
                      spacing: 8,
                      children: [
                        if (apartment.active != null)
                          Chip(
                            avatar: Icon(
                              apartment.active!
                                  ? Icons.check_circle
                                  : Icons.cancel,
                            ),
                            label: Text(
                              apartment.active! ? 'Ativo' : 'Inativo',
                            ),
                            backgroundColor: apartment.active!
                                ? theme.colorScheme.primaryContainer
                                : theme.colorScheme.errorContainer,
                            labelStyle: TextStyle(
                              color: apartment.active!
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onErrorContainer,
                              fontWeight: .bold,
                            ),
                          ),
                        if (apartment.rented != null)
                          Chip(
                            avatar: const Icon(Icons.home),
                            label: Text(
                              apartment.rented! ? 'Alugado' : 'Proprio',
                            ),
                            backgroundColor:
                                theme.colorScheme.secondaryContainer,
                            labelStyle: TextStyle(
                              color: theme.colorScheme.onSecondaryContainer,
                              fontWeight: .w500,
                            ),
                          ),
                      ],
                    ),
                  ],
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
    properties.add(
      DiagnosticsProperty<ApartmentEntity>('apartment', apartment),
    );
  }
}

class _ApartmentInfo extends StatelessWidget {
  const _ApartmentInfo({required this.apartment});

  final ApartmentEntity apartment;

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
              'Informaçoes do Apartamento',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
            ),
            if (apartment.tower != null)
              _InfoRow(
                icon: Icons.business,
                label: 'Torre',
                value: apartment.tower!,
              ),
            if (apartment.floor != null)
              _InfoRow(
                icon: Icons.layers,
                label: 'Andar',
                value: apartment.floor!,
              ),
            if (apartment.door != null)
              _InfoRow(
                icon: Icons.door_front_door,
                label: 'Porta',
                value: apartment.door!,
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ApartmentEntity>('apartment', apartment),
    );
  }
}

class _ResidentsList extends StatelessWidget {
  const _ResidentsList({required this.residents});

  final List<ResidentEntity> residents;

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
              'Moradores (${residents.length})',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
            ),
            ...residents.map(
              (final resident) => ListTile(
                contentPadding: .zero,
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
                title: Text(resident.userName),
                subtitle: resident.owner ? const Text('Proprietário') : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<ResidentEntity>('residents', residents));
  }
}

class _ApartmentMetadata extends StatelessWidget {
  const _ApartmentMetadata({required this.apartment});

  final ApartmentEntity apartment;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            Text(
              'Informações do Sistema',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
            ),
            _InfoRow(
              icon: Icons.apartment,
              label: 'ID do Condominio',
              value: apartment.condominiumId.toString(),
            ),
            if (apartment.createdAt != null)
              _InfoRow(
                icon: Icons.calendar_today,
                label: 'Cadastrado em',
                value: dateFormat.format(apartment.createdAt!),
              ),
            if (apartment.updatedAt != null)
              _InfoRow(
                icon: Icons.update,
                label: 'Atualizado em',
                value: dateFormat.format(apartment.updatedAt!),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ApartmentEntity>('apartment', apartment),
    );
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
