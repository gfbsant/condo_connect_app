import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/apartment_entity.dart';
import '../providers/apartment_providers.dart';
import '../providers/apartment_state.dart';
import 'apartment_detail_page.dart';
import 'apartment_form_page.dart';

class ApartmentListPage extends ConsumerStatefulWidget {
  const ApartmentListPage({required this.condominiumId, super.key});

  final int condominiumId;

  @override
  ConsumerState<ApartmentListPage> createState() => _ApartmentListPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('condominiumId', condominiumId));
  }
}

class _ApartmentListPageState extends ConsumerState<ApartmentListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadApartments();
    });
  }

  Future<void> _loadApartments() async {
    await ref
        .read(apartmentNotifierAccessor)
        .getApartmentsByCondo(widget.condominiumId);
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
    final isSearching = state.status == .searching;
    final List<ApartmentEntity> apartments = state.apartments;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ApartmentListAppBar(createCallback: _navigateToCreate()),
      body: ApartmentListBody(
        apartments: apartments,
        detailsCallback: _navigateToDetail,
        refreshCallback: _loadApartments,
        isSearching: isSearching,
      ),
    );
  }

  void _clearMessages() {
    ref.read(apartmentNotifierAccessor).clearMessages();
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

  Future<void> _navigateToCreate() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ApartmentFormPage(condominiumId: widget.condominiumId),
      ),
    );
  }

  Future<void> _navigateToDetail(final int apartmentId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ApartmentDetailPage(apartmentId: apartmentId),
      ),
    );
  }
}

class ApartmentListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ApartmentListAppBar({required this.createCallback, super.key});

  final Future<void> createCallback;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Apartamentos'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        onPressed: () async {
          await createCallback;
        },
        icon: const Icon(Icons.add_home),
        tooltip: 'Adicionar Apartamento',
      ),
    ],
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Future<void>>('createCallback', createCallback),
    );
  }
}

class ApartmentListBody extends StatelessWidget {
  const ApartmentListBody({
    required this.apartments,
    required this.detailsCallback,
    required this.refreshCallback,
    required this.isSearching,
    super.key,
  });

  final List<ApartmentEntity> apartments;
  final Future<void> Function(int) detailsCallback;
  final Future<void> Function() refreshCallback;
  final bool isSearching;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: isSearching
        ? const _LoadingView()
        : apartments.isEmpty
        ? const _EmptyView()
        : _ApartmentList(
            apartments: apartments,
            onRefresh: refreshCallback,
            onTap: detailsCallback,
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<ApartmentEntity>('apartments', apartments))
      ..add(
        ObjectFlagProperty<Future<void> Function(int)>.has(
          'detailsCallback',
          detailsCallback,
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
        Text('Carregando apartamentos...'),
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
            Icons.apartment_outlined,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant.withAlpha(128),
          ),
          Text(
            'Nenhum apartamento cadastrado',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione apartamentos ao condominio',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApartmentList extends StatelessWidget {
  const _ApartmentList({
    required this.apartments,
    required this.onRefresh,
    required this.onTap,
  });

  final List<ApartmentEntity> apartments;
  final Future<void> Function(int) onTap;
  final Future<void> Function() onRefresh;

  @override
  Widget build(final BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: apartments.length,
      itemBuilder: (_, final index) => _ApartmentCard(
        apartment: apartments[index],
        onTap: () async {
          final int? id = apartments[index].id;
          if (id != null) {
            await onTap(id);
          }
        },
      ),
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<ApartmentEntity>('apartments', apartments))
      ..add(ObjectFlagProperty<Future<void> Function(int)>.has('onTap', onTap))
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onRefresh', onRefresh),
      );
  }
}

class _ApartmentCard extends StatelessWidget {
  const _ApartmentCard({required this.apartment, required this.onTap});

  final ApartmentEntity apartment;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            Row(
              spacing: 12,
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    Icons.apartment,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        'Apartamento ${apartment.number}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                      if (apartment.tower != null || apartment.floor != null)
                        Text(
                          [
                            if (apartment.tower != null)
                              'Torre ${apartment.tower}',
                            if (apartment.floor != null)
                              'Andar ${apartment.floor}',
                          ].join(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                if (apartment.active != null)
                  Chip(
                    avatar: Icon(
                      apartment.active! ? Icons.check_circle : Icons.cancel,
                    ),
                    label: Text(
                      apartment.active! ? 'Ativo' : 'Inativa',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: apartment.active!
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.errorContainer,
                    materialTapTargetSize: .shrinkWrap,
                  ),
                if (apartment.rented != null)
                  Chip(
                    avatar: const Icon(Icons.home, size: 16),
                    label: Text(apartment.rented! ? 'Alugado' : 'Próprio'),
                  ),
                if (apartment.createdAt != null)
                  Chip(
                    avatar: const Icon(Icons.calendar_today),
                    label: Text(
                      'Desde ${dateFormat.format(apartment.createdAt!)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
            if (apartment.residents != null &&
                apartment.residents!.isNotEmpty) ...[
              const Divider(),
              Row(
                spacing: 4,
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  Text(
                    '${apartment.residents!.length} '
                    '${apartment.residents!.length == 1 ? 'Morador' : 'Moradores'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ApartmentEntity>('apartment', apartment))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}
