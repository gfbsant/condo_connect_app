import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../apartments/presentation/pages/apartment_form_page.dart';
import '../../domain/entities/condominium_entity.dart';
import '../providers/condo_providers.dart';
import '../providers/condo_state.dart';

class CondoDetailsModal extends ConsumerStatefulWidget {
  const CondoDetailsModal({required this.condoId, super.key});

  final int condoId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CondoDetailsModalState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('condoId', condoId));
  }
}

class _CondoDetailsModalState extends ConsumerState<CondoDetailsModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(condoNotifierAccessor).getCondoById(widget.condoId);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final CondoState condoState = ref.watch(condoNotifierProvider);
    final bool isLoading = ref.watch(isLoadingProvider);
    final CondominiumEntity? selectedCondo = ref.watch(selectedCondoProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _ModalHeader(
            onClose: () {
              ref.read(condoNotifierAccessor).clearSelectedCondo();
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: isLoading
                ? const _LoadingContent()
                : selectedCondo != null
                ? _DetailsContent(
                    condo: selectedCondo,
                    hasJoinRequest: condoState.hasJoinRequest,
                    isRequestingJoin:
                        condoState.status == CondoStatus.requestingJoin,
                    onRequestJoin: _handleRequestJoin,
                  )
                : const _ErrorContent(),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRequestJoin() async {
    await HapticFeedback.lightImpact();

    final CondominiumEntity? selectedCondo = ref.read(selectedCondoProvider);

    if (!context.mounted || selectedCondo == null) {
      return;
    }

    ref.read(condoNotifierAccessor).clearSelectedCondo();
    Navigator.of(context).pop();

    final bool? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ApartmentFormPage(condominiumId: selectedCondo.id!),
      ),
    );

    if (result != null && result && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            spacing: 8,
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              Expanded(
                child: Text(
                  'Solicitação enviada! O administrador irá aprovar seu apartamento.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _ModalHeader extends StatelessWidget {
  const _ModalHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(final BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
      ),
    ),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            'Detalhes do Condominio',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
      ],
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has('onClose', onClose));
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(final BuildContext context) => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [CircularProgressIndicator(), Text('Carregando detalhes...')],
    ),
  );
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent();

  @override
  Widget build(final BuildContext context) => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        Icon(Icons.error, size: 64, color: Colors.red),
        Text('Erro ao carregar detalhes'),
      ],
    ),
  );
}

class _DetailsContent extends StatelessWidget {
  const _DetailsContent({
    required this.condo,
    required this.hasJoinRequest,
    required this.isRequestingJoin,
    required this.onRequestJoin,
  });

  final CondominiumEntity condo;
  final bool? hasJoinRequest;
  final bool isRequestingJoin;
  final Future<void> Function() onRequestJoin;

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      spacing: 20,
      children: [
        _CondoHeader(condo: condo),
        _AdrressSection(condo: condo),
        const SizedBox(height: 20),
        _JoinRequestButton(
          hasJoinRequest: hasJoinRequest,
          isRequestingJoin: isRequestingJoin,
          onPressed: onRequestJoin,
        ),
      ],
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<CondominiumEntity>('condo', condo))
      ..add(DiagnosticsProperty<bool?>('hasJoinRequest', hasJoinRequest))
      ..add(DiagnosticsProperty<bool>('isRequestingJoin', isRequestingJoin))
      ..add(
        ObjectFlagProperty<VoidCallback>.has('onRequestJoin', onRequestJoin),
      );
  }
}

class _CondoHeader extends StatelessWidget {
  const _CondoHeader({required this.condo});

  final CondominiumEntity condo;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
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
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'ID: ${condo.id}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Bairro: ${condo.neighborhood}',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CondominiumEntity>('condo', condo));
  }
}

class _AdrressSection extends StatelessWidget {
  const _AdrressSection({required this.condo});

  final CondominiumEntity condo;

  Future<void> _openInMaps() async {
    final address =
        '${condo.address}, ${condo.number}, ${condo.neighborhood}, '
        '${condo.city} - ${condo.state}';
    final String encodedAddress = Uri.encodeComponent(address);
    final url = 'https://www.google.com/maps/search/$encodedAddress';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Row(
              spacing: 8,
              children: [
                Icon(Icons.location_on, color: theme.colorScheme.primary),
                Text(
                  'Endereço',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: _openInMaps,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(78),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      '${condo.address}, ${condo.number}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${condo.neighborhood} - ${condo.city}/${condo.state}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        Text(
                          'Abrir no Google Maps',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
    properties.add(DiagnosticsProperty<CondominiumEntity>('condo', condo));
  }
}

class _JoinRequestButton extends StatelessWidget {
  const _JoinRequestButton({
    required this.hasJoinRequest,
    required this.isRequestingJoin,
    required this.onPressed,
  });

  final bool? hasJoinRequest;
  final bool isRequestingJoin;
  final Future<void> Function() onPressed;

  @override
  Widget build(final BuildContext context) {
    final bool isPending = hasJoinRequest ?? false;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isPending || isRequestingJoin
            ? null
            : () async {
                await onPressed();
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isPending
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : null,
        ),
        child: SizedBox(
          height: 20,
          child: isRequestingJoin
              ? const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Text(
                  isPending ? 'PARTICIPAÇÃO PENDENTE' : 'PEDIR PARA PARTICIPAR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isPending
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : null,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool?>('hasJoinRequest', hasJoinRequest))
      ..add(DiagnosticsProperty<bool>('isRequestingJoin', isRequestingJoin))
      ..add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
  }
}
