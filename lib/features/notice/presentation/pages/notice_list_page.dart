import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/notice_entity.dart';
import '../providers/notice_notifier.dart';
import '../providers/notice_providers.dart';
import '../providers/notice_state.dart';
import '../widgets/notice_card.dart';
import 'notice_detail_page.dart';
import 'notice_form_page.dart';

class NoticeListPage extends ConsumerStatefulWidget {
  const NoticeListPage({required this.condoId, this.apartmentId, super.key});

  final int condoId;
  final int? apartmentId;

  @override
  ConsumerState<NoticeListPage> createState() => _NoticeListPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('condoId', condoId))
      ..add(IntProperty('apartmentId', apartmentId));
  }
}

class _NoticeListPageState extends ConsumerState<NoticeListPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadNotices() async {
    final NoticeNotifier notifier = ref.read(noticeNotifierAccessor);
    if (widget.apartmentId != null) {
      await notifier.getNoticesByApartment(widget.apartmentId!);
    } else {
      await notifier.getNoticesByCondo(widget.condoId);
    }
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen<String?>(
        noticeNotifierProvider.select((final state) => state.errorMessage),
        (_, final errorMessage) {
          if (errorMessage != null) {
            _showErrorSnackBar(errorMessage);
            _clearMessages();
          }
        },
      )
      ..listen(
        noticeNotifierProvider.select((final state) => state.successMessage),
        (_, final successMessage) {
          if (successMessage != null) {
            _showSuccessSnackBar(successMessage);
            _clearMessages();
          }
        },
      );

    final NoticeState state = ref.watch(noticeNotifierProvider);
    final List<NoticeEntity> notices = state.notices;
    final isLoading = state.status == .loading;
    final isSearching = state.status == .searching;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: NoticeListAppBar(fromApartment: widget.apartmentId != null),
      body: NoticeListBody(
        notices: notices,
        isSearching: isSearching,
        refreshCallback: _loadNotices,
        detailsCallback: _navigateToDetail,
      ),
      floatingActionButton: widget.apartmentId != null
          ? FloatingActionButton.extended(
              onPressed: isLoading ? null : _navigateToForm,
              icon: const Icon(Icons.add),
              label: const Text('Novo Aviso'),
            )
          : null,
    );
  }

  void _clearMessages() => ref.read(noticeNotifierAccessor).clearMessages();

  void _showSuccessSnackBar(final String message) =>
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
        ),
      );

  void _showErrorSnackBar(final String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            spacing: 8,
            children: [
              const Icon(Icons.error, color: Colors.white, size: 20),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );

  Future<void> _navigateToDetail(final int noticeId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => NoticeDetailPage(noticeId: noticeId)),
    );
  }

  Future<void> _navigateToForm() async {
    final int? apartmentId = widget.apartmentId;
    if (apartmentId != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => NoticeFormPage(apartmentId: apartmentId),
        ),
      );
    }
  }
}

class NoticeListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NoticeListAppBar({required this.fromApartment, super.key});

  final bool fromApartment;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: Text(
      fromApartment ? 'Avisos do Apartamento' : 'Avisos do Condominio',
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('fromApartment', fromApartment));
  }
}

class NoticeListBody extends StatelessWidget {
  const NoticeListBody({
    required this.notices,
    required this.isSearching,
    required this.refreshCallback,
    required this.detailsCallback,
    super.key,
  });

  final List<NoticeEntity> notices;
  final bool isSearching;
  final Future<void> Function() refreshCallback;
  final Future<void> Function(int) detailsCallback;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: isSearching && notices.isEmpty
        ? const _LoadingView()
        : notices.isEmpty
        ? _EmptyView(onRefresh: refreshCallback)
        : RefreshIndicator(
            onRefresh: refreshCallback,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notices.length,
              itemBuilder: (final context, final index) {
                final NoticeEntity notice = notices[index];
                return NoticeCard(
                  notice: notice,
                  onTap: () async {
                    await detailsCallback(notice.id!);
                  },
                );
              },
            ),
          ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<NoticeEntity>('notices', notices))
      ..add(DiagnosticsProperty<bool>('isSearching', isSearching))
      ..add(
        ObjectFlagProperty<Future<void> Function()>.has(
          'refreshCallback',
          refreshCallback,
        ),
      )
      ..add(
        ObjectFlagProperty<Future<void> Function(int)>.has(
          'detailsCallback',
          detailsCallback,
        ),
      );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(final BuildContext context) => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [CircularProgressIndicator(), Text('Carregando avisos...')],
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Icon(
              Icons.notification_important_outlined,
              size: 64,
              color: theme.colorScheme.secondary,
            ),
            Text(
              'Nenhum aviso encontrado',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              'Quando houver avisos, eles aparecerão aqui',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Atualizar'),
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
      ObjectFlagProperty<VoidCallback>.has('onRefresh', onRefresh),
    );
  }
}
