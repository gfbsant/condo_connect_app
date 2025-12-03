import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/resident_entity.dart';
import '../providers/resident_provider.dart';
import '../providers/resident_state.dart';
import 'resident_detail_page.dart';
import 'resident_form_page.dart';

class ResidentListPage extends ConsumerStatefulWidget {
  const ResidentListPage({required this.apartmentId, super.key});

  final int apartmentId;

  @override
  ConsumerState<ResidentListPage> createState() => _ResidentListPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('apartmentId', apartmentId));
  }
}

class _ResidentListPageState extends ConsumerState<ResidentListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadResidents();
    });
  }

  Future<void> _loadResidents() async {
    await ref
        .read(residentNotifierAccessor)
        .getResidentsByApartment(widget.apartmentId);
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen(
        residentNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen(
        residentNotifierProvider.select((final state) => state.successMessage),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );

    final ResidentState state = ref.watch(residentNotifierProvider);
    final isSearching = state.status == .searching;
    final List<ResidentEntity> residents = state.residents;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ResidentListAppBar(createCallback: _navigateToCreate),
      body: ResidentListBody(
        residents: residents,
        isSearching: isSearching,
        detailsCallback: _navigateToDetail,
        refreshCallback: _loadResidents,
      ),
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

  Future<void> _navigateToCreate() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResidentFormPage(apartmentId: widget.apartmentId),
      ),
    );
  }

  Future<void> _navigateToDetail(final int residentId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResidentDetailPage(
          apartmentId: widget.apartmentId,
          residentId: residentId,
        ),
      ),
    );
  }
}

class ResidentListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ResidentListAppBar({required this.createCallback, super.key});

  final Future<void> Function() createCallback;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Moradores'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        onPressed: () async {
          await createCallback();
        },
        icon: const Icon(Icons.person_add, size: 20),
        tooltip: 'Adicionar Morador',
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

class ResidentListBody extends StatelessWidget {
  const ResidentListBody({
    required this.residents,
    required this.isSearching,
    required this.detailsCallback,
    required this.refreshCallback,
    super.key,
  });

  final List<ResidentEntity> residents;
  final bool isSearching;
  final Future<void> Function(int) detailsCallback;
  final Future<void> Function() refreshCallback;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: isSearching
        ? const _LoadingView()
        : residents.isEmpty
        ? const _EmptyView()
        : _ResidentList(
            onRefresh: refreshCallback,
            onTap: detailsCallback,
            residents: residents,
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<ResidentEntity>('residents', residents))
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
        Text('Carregando moradores...'),
      ],
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: .center,
      spacing: 16,
      children: [
        Icon(
          Icons.people_outline,
          size: 80,
          color: theme.colorScheme.onSurfaceVariant.withAlpha(128),
        ),
        Text(
          'Nenhum morado cadastrado',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          'Toque no botão + para adicionar',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withAlpha(176),
          ),
        ),
      ],
    );
  }
}

class _ResidentList extends StatelessWidget {
  const _ResidentList({
    required this.onRefresh,
    required this.onTap,
    required this.residents,
  });

  final List<ResidentEntity> residents;
  final Future<void> Function(int) onTap;
  final Future<void> Function() onRefresh;

  @override
  Widget build(final BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: ListView.builder(
      itemCount: residents.length,
      itemBuilder: (_, final index) {
        final ResidentEntity resident = residents[index];
        return _ResidentCard(
          resident: resident,
          onTap: () async {
            await onTap(resident.id);
          },
        );
      },
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<ResidentEntity>('residents', residents))
      ..add(ObjectFlagProperty<Future<void> Function(int)>.has('onTap', onTap))
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has('onRefresh', onRefresh),
      );
  }
}

class _ResidentCard extends StatelessWidget {
  const _ResidentCard({required this.onTap, required this.resident});

  final ResidentEntity resident;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      margin: const .only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const .symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            size: 28,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          resident.userName,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
        ),
        subtitle: resident.owner
            ? Row(
                spacing: 4,
                children: [
                  Icon(Icons.star, size: 16, color: theme.colorScheme.primary),
                  Text(
                    'Proprietário',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ],
              )
            : const Text('Morador'),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ResidentEntity>('resident', resident))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}
