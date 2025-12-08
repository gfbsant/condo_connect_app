import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/reservation_entity.dart';
import '../providers/reservation_providers.dart';
import '../providers/reservation_state.dart';
import 'reservation_form_page.dart';

class ReservationListPage extends ConsumerStatefulWidget {
  const ReservationListPage({
    super.key,
    this.apartmentId,
    this.facilityId,
    this.condominiumId,
  });

  final int? facilityId;
  final int? apartmentId;
  final int? condominiumId;

  @override
  ConsumerState<ReservationListPage> createState() =>
      _ReservationListPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('facilityId', facilityId))
      ..add(IntProperty('apartmentId', apartmentId))
      ..add(IntProperty('condominiumId', condominiumId));
  }
}

class _ReservationListPageState extends ConsumerState<ReservationListPage> {
  int? get _facilityId => widget.facilityId;

  int? get _apartmentId => widget.apartmentId;

  int? get _condoId => widget.condominiumId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadItems();
    });
  }

  Future<void> _loadItems() async {
    if (_facilityId != null) {
      await ref
          .read(reservationNotifierAccessor)
          .getReservationsByFacility(_facilityId!);
    } else if (_apartmentId != null) {
      await ref
          .read(reservationNotifierAccessor)
          .getReservationsByApartment(_apartmentId!);
    }
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen(
        reservationNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen(
        reservationNotifierProvider.select(
          (final state) => state.successMessage,
        ),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );
    final ReservationState state = ref.watch(reservationNotifierProvider);
    final isSearching = state.status == .searching;
    final List<ReservationEntity> reservations = state.reservations;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ReservationListAppBar(
        createAllowed: _apartmentId != null && _condoId != null,
        createCallback: _navigateToCreate,
      ),
      body: ReservationListBody(
        reservations: reservations,
        deleteCallback: _handleDelete,
        refreshCallback: _loadItems,
        isSearching: isSearching,
      ),
    );
  }

  void _clearMessages() {
    ref.read(reservationNotifierAccessor).clearMessages();
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
            const Icon(Icons.check_circle),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: .floating,
      ),
    );
  }

  Future<void> _navigateToCreate() async {
    if (_apartmentId != null && _condoId != null) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ReservationFormPage(
            apartmentId: _apartmentId!,
            condominiumId: _condoId!,
          ),
        ),
      );
    }
  }

  Future<void> _handleDelete(final int reservationId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Deseja realmente excluir esta reserva?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed != null && confirmed) {
      await ref
          .read(reservationNotifierAccessor)
          .deleteReservation(reservationId);
    }
  }
}

class ReservationListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ReservationListAppBar({
    required this.createAllowed,
    required this.createCallback,
    super.key,
  });

  final bool createAllowed;
  final Future<void> Function() createCallback;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Reservas'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: createAllowed
        ? [
            IconButton(
              onPressed: () async {
                await createCallback();
              },
              icon: const Icon(Icons.add, size: 20),
              tooltip: 'Nova Reserva',
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
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'createCallback',
          createCallback,
        ),
      )
      ..add(DiagnosticsProperty<bool>('createAllowed', createAllowed));
  }
}

class ReservationListBody extends StatelessWidget {
  const ReservationListBody({
    required this.reservations,
    required this.deleteCallback,
    required this.refreshCallback,
    required this.isSearching,
    super.key,
  });

  final List<ReservationEntity> reservations;
  final Future<void> Function(int) deleteCallback;
  final Future<void> Function() refreshCallback;
  final bool isSearching;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: isSearching
        ? const _LoadingView()
        : reservations.isEmpty
        ? const _EmptyView()
        : _ReservationList(
            reservations: reservations,
            onRefresh: refreshCallback,
            onDelete: deleteCallback,
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<ReservationEntity>('reservations', reservations))
      ..add(
        ObjectFlagProperty<Future<void> Function(int)>.has(
          'deleteCallback',
          deleteCallback,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'refreshCallback',
          refreshCallback,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isSearching', isSearching));
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

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        spacing: 16,
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant.withAlpha(128),
          ),
          Text(
            'Nenhuma reserva encontrada',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crie uma nova reserva',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationList extends StatelessWidget {
  const _ReservationList({
    required this.reservations,
    required this.onRefresh,
    required this.onDelete,
  });

  final List<ReservationEntity> reservations;
  final Future<void> Function(int) onDelete;
  final Future<void> Function() onRefresh;

  @override
  Widget build(final BuildContext context) => RefreshIndicator(
    onRefresh: () async {
      await onRefresh();
    },
    child: ListView.builder(
      itemCount: reservations.length,
      itemBuilder: (_, final index) {
        final ReservationEntity reservation = reservations[index];
        return _ReservationCard(
          reservation: reservation,
          onDelete: () async {
            final int? id = reservation.id;
            if (id != null) {
              await onDelete(id);
            }
          },
        );
      },
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<ReservationEntity>('reservations', reservations))
      ..add(
        ObjectFlagProperty<Future<void> Function(int)>.has(
          'onDelete',
          onDelete,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onRefresh', onRefresh),
      );
  }
}

class _ReservationCard extends StatelessWidget {
  const _ReservationCard({required this.reservation, required this.onDelete});

  final ReservationEntity reservation;
  final VoidCallback onDelete;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const .all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              Icons.event,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Apartamento ${reservation.apartmentId}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: .bold,
                  ),
                ),
                if (reservation.scheduledDate != null)
                  Text(
                    dateFormat.format(reservation.scheduledDate!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            color: theme.colorScheme.error,
            tooltip: 'Excluir reserva',
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ReservationEntity>('reservation', reservation))
      ..add(ObjectFlagProperty<VoidCallback>.has('onDelete', onDelete));
  }
}
