import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/facility_entity.dart';
import '../providers/facility_providers.dart';
import '../providers/facility_state.dart';
import 'facility_detail_page.dart';
import 'facility_form_page.dart';

class FacilityListPage extends ConsumerStatefulWidget {
  const FacilityListPage({required this.condominiumId, super.key});

  final int condominiumId;

  @override
  ConsumerState<FacilityListPage> createState() => _FacilityListPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('condominiumId', condominiumId));
  }
}

class _FacilityListPageState extends ConsumerState<FacilityListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadFacilities();
    });
  }

  Future<void> _loadFacilities() async {
    await ref
        .read(facilityNotifierAccessor)
        .getFacilitiesByCondo(widget.condominiumId);
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen(
        facilityNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen(
        facilityNotifierProvider.select((final state) => state.successMessage),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );

    final FacilityState state = ref.watch(facilityNotifierProvider);
    final isSearching = state.status == .searching;
    final List<FacilityEntity> facilities = state.facilities;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: FacilityListAppBar(createCallback: _navigateToCreate),
      body: FacilityListBody(
        facilities: facilities,
        detailsCallback: _navigateToDetail,
        refreshCallback: _loadFacilities,
        isSearching: isSearching,
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

  Future<void> _navigateToCreate() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FacilityFormPage(condominiumId: widget.condominiumId),
      ),
    );
  }

  Future<void> _navigateToDetail(final int facilityId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FacilityDetailPage(
          facilityId: facilityId,
          condominiumId: widget.condominiumId,
        ),
      ),
    );
  }
}

class FacilityListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FacilityListAppBar({required this.createCallback, super.key});

  final Future<void> Function() createCallback;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Áreas Comuns'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        onPressed: createCallback,
        icon: const Icon(Icons.add, size: 20),
        tooltip: 'Adicionar Área Comum',
      ),
    ],
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<Future<void> Function()>.has(
        'createCallback',
        createCallback,
      ),
    );
  }
}

class FacilityListBody extends StatelessWidget {
  const FacilityListBody({
    required this.facilities,
    required this.detailsCallback,
    required this.refreshCallback,
    required this.isSearching,
    super.key,
  });

  final List<FacilityEntity> facilities;
  final Future<void> Function(int) detailsCallback;
  final Future<void> Function() refreshCallback;
  final bool isSearching;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: isSearching
        ? const _LoadingView()
        : facilities.isEmpty
        ? const _EmptyView()
        : _FacilityList(
            facilities: facilities,
            onRefresh: refreshCallback,
            onTap: detailsCallback,
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<FacilityEntity>('facilities', facilities))
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
        Text('Carregando áreas comuns'),
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
            Icons.meeting_room_outlined,
            size: 80,
            color: theme.colorScheme.onSurfaceVariant.withAlpha(128),
          ),
          Text(
            'Nenhuma área comum cadastrada',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione áreas comuns ao condomínio',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilityList extends StatelessWidget {
  const _FacilityList({
    required this.facilities,
    required this.onRefresh,
    required this.onTap,
  });

  final List<FacilityEntity> facilities;
  final Future<void> Function(int) onTap;
  final Future<void> Function() onRefresh;

  @override
  Widget build(final BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: facilities.length,
      itemBuilder: (_, final index) {
        final FacilityEntity facility = facilities[index];
        return _FacilityCard(
          facility: facility,
          onTap: () async {
            final int? id = facilities[index].id;
            if (id != null) {
              await onTap(id);
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
      ..add(IterableProperty<FacilityEntity>('facilities', facilities))
      ..add(ObjectFlagProperty<Future<void> Function(int)>.has('onTap', onTap))
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onRefresh', onRefresh),
      );
  }
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({required this.facility, required this.onTap});

  final FacilityEntity facility;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: r'R$',
    );
    return Card(
      margin: const .only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(16),
        child: Padding(
          padding: const .all(16),
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
                      Icons.meeting_room,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          facility.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                        if (facility.description != null &&
                            facility.description!.isNotEmpty)
                          Text(
                            facility.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (facility.tax != null)
                Row(
                  spacing: 8,
                  children: [
                    Text(
                      'Taxa: ${currencyFormat.format(facility.tax)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: .w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<FacilityEntity>('facility', facility))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}
