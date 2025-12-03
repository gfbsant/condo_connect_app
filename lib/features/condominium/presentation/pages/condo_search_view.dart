//
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/condominium_entity.dart';
import '../providers/condo_providers.dart';
import '../widgets/condo_details_modal.dart';

class CondoSearchView extends ConsumerStatefulWidget {
  const CondoSearchView({
    super.key,
    this.initialSearchTerm,
    this.selectedCondoId,
  });

  final String? initialSearchTerm;
  final int? selectedCondoId;

  @override
  ConsumerState<CondoSearchView> createState() => _CondoSearchViewState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('initialSearchTerm', initialSearchTerm))
      ..add(IntProperty('selectedCondoId', selectedCondoId));
  }
}

class _CondoSearchViewState extends ConsumerState<CondoSearchView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialSearchTerm != null) {
      _searchController.text = widget.initialSearchTerm!;
    }

    WidgetsBinding.instance.addPostFrameCallback((final _) async {
      await _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (widget.initialSearchTerm != null) {
      await ref
          .read(condoNotifierAccessor)
          .searchCondos(widget.initialSearchTerm);
    } else {
      await ref.read(condoNotifierAccessor).searchCondos();
    }

    if (widget.selectedCondoId != null) {
      await _showCondoDetails(widget.selectedCondoId);
    }
  }

  void _showErrorSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
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
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
        ),
      ),
    );
  }

  Future<void> _showCondoDetails(final int? condoId) async {
    if (condoId != null) {
      await ref.read(condoNotifierAccessor).getCondoById(condoId);
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (final context) => CondoDetailsModal(condoId: condoId),
      );
    }
  }

  Future<void> _handleSearch() async {
    FocusScope.of(context).unfocus();
    await ref.read(condoNotifierAccessor).searchCondos(_searchController.text);
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen<String?>(errorMessageProvider, (_, final errorMessage) {
        if (errorMessage != null) {
          _showErrorSnackBar(errorMessage);
          ref.read(condoNotifierAccessor).clearMessages();
        }
      })
      ..listen<String?>(successMessageProvider, (_, final successMessage) {
        if (successMessage != null) {
          _showSuccessSnackBar(successMessage);
          ref.read(condoNotifierAccessor).clearMessages();
        }
      });

    final List<CondominiumEntity> condos = ref.watch(condosProvider);
    final bool isLoading = ref.watch(isLoadingProvider);
    final bool isSearching = ref.watch(isSearchingProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CondoSearchAppBar(),
      body: CondoSearchBody(
        searchController: _searchController,
        condos: condos,
        isSearching: isSearching,
        isLoading: isLoading,
        searchCallback: _handleSearch,
        detailsCallback: _showCondoDetails,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class CondoSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CondoSearchAppBar({super.key});

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Pesquisar Condomínios'),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CondoSearchBody extends StatelessWidget {
  const CondoSearchBody({
    required this.searchController,
    required this.condos,
    required this.isSearching,
    required this.isLoading,
    required this.searchCallback,
    required this.detailsCallback,
    super.key,
  });

  final TextEditingController searchController;
  final List<CondominiumEntity> condos;
  final bool isSearching;
  final bool isLoading;
  final Future<void> Function() searchCallback;
  final Future<void> Function(int?) detailsCallback;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: Column(
      children: [
        _SearchHeader(
          searchController: searchController,
          isSearching: isSearching,
          onSearch: searchCallback,
        ),
        Expanded(
          child: isLoading && condos.isEmpty
              ? const _LoadingView()
              : condos.isEmpty
              ? _EmptyView(hasSearchTerm: searchController.text.isNotEmpty)
              : RefreshIndicator(
                  onRefresh: () async {
                    await searchCallback();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: condos.length,
                    itemBuilder: (final context, final index) {
                      final CondominiumEntity condo = condos[index];
                      return _CondoListItem(
                        condo: condo,
                        onTap: () async {
                          await detailsCallback(condo.id);
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'searchController',
          searchController,
        ),
      )
      ..add(IterableProperty<CondominiumEntity>('condos', condos))
      ..add(DiagnosticsProperty<bool>('isSearching', isSearching))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'searchCallback',
          searchCallback,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function(int?)>.has(
          'detailsCallback',
          detailsCallback,
        ),
      );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.searchController,
    required this.isSearching,
    required this.onSearch,
  });

  final TextEditingController searchController;
  final bool isSearching;
  final VoidCallback onSearch;

  @override
  Widget build(final BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withAlpha(78),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
    ),
    child: Column(
      spacing: 12,
      children: [
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: searchController,
                builder: (final context, final _) => TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Buscar Condomínios',
                    hintText: 'Digite o nome do condomínio',
                  ),
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (final _) => onSearch(),
                ),
              ),
            ),
            _SearchButton(
              isEnabled: searchController.text.isNotEmpty && !isSearching,
              isLoading: isSearching,
              onPressed: onSearch,
            ),
          ],
        ),
      ],
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<TextEditingController>(
          'searchController',
          searchController,
        ),
      )
      ..add(DiagnosticsProperty<bool>('isSearching', isSearching))
      ..add(ObjectFlagProperty<VoidCallback>.has('onSearch', onSearch));
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) => ElevatedButton(
    onPressed: isEnabled ? onPressed : null,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(12),
      minimumSize: const Size(80, 40),
    ),
    child: isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text('BUSCAR', style: TextStyle(fontWeight: FontWeight.bold)),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isEnabled', isEnabled))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading))
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(final BuildContext context) => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        CircularProgressIndicator(),
        Text('Carregando condomínios...'),
      ],
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.hasSearchTerm});

  final bool hasSearchTerm;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Icon(
                hasSearchTerm ? Icons.search_off : Icons.apartment_outlined,
                size: 64,
                color: theme.colorScheme.secondary,
              ),
              Text(
                hasSearchTerm
                    ? 'Nenhum condomínio encontrado'
                    : 'Nenhum condominio cadastrado',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
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
    properties.add(DiagnosticsProperty<bool>('hasSearchTerm', hasSearchTerm));
  }
}

class _CondoListItem extends StatelessWidget {
  const _CondoListItem({required this.condo, required this.onTap});

  final CondominiumEntity condo;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      condo.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ID: ${condo.id}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 4,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  Expanded(
                    child: Text(
                      '${condo.address}, ${condo.number} - '
                      '${condo.neighborhood}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_city_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${condo.city} - ${condo.state}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Text(
                    'CEP: ${condo.zipcode}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
      ..add(DiagnosticsProperty<CondominiumEntity>('condo', condo))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}
