import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_type.dart';
import '../providers/notice_providers.dart';
import '../providers/notice_state.dart';
import '../widgets/notice_status_chip.dart';
import 'notice_form_page.dart';

class NoticeDetailPage extends ConsumerStatefulWidget {
  const NoticeDetailPage({required this.noticeId, super.key});

  final int noticeId;

  @override
  ConsumerState<NoticeDetailPage> createState() => _NoticeDetailPageState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('noticeId', noticeId));
  }
}

class _NoticeDetailPageState extends ConsumerState<NoticeDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(noticeNotifierAccessor).getNoticeById(widget.noticeId);
    });
  }

  @override
  Widget build(final BuildContext context) {
    ref
      ..listen(
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
    final isLoading = state.status == NoticeStatus.loading;
    final NoticeEntity? notice = state.selectedNotice;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: NoticeDetailAppBar(
        deleteCallback: _handleDelete,
        editCallback: _navigateToEdit,
      ),
      body: NoticeDetailBody(notice: notice, isLoading: isLoading),
    );
  }

  void _clearMessages() => ref.read(noticeNotifierAccessor).clearMessages();

  void _showErrorSnackBar(final String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );

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

  Future<void> _handleDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este aviso?'),
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

    if (confirmed != null && confirmed && mounted) {
      final bool success = await ref
          .read(noticeNotifierAccessor)
          .deleteNotice(widget.noticeId);

      if (success && mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _navigateToEdit(final NoticeEntity notice) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            NoticeFormPage(apartmentId: notice.apartmentId, notice: notice),
      ),
    );
  }
}

class NoticeDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NoticeDetailAppBar({
    required this.deleteCallback,
    required this.editCallback,
    super.key,
    this.notice,
  });

  final NoticeEntity? notice;
  final Future<void> Function(NoticeEntity) editCallback;
  final Future<void> Function() deleteCallback;

  @override
  Widget build(final BuildContext context) => AppBar(
    title: const Text('Detalhes do Aviso'),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: notice != null
        ? [
            IconButton(
              onPressed: () async {
                await editCallback(notice!);
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
      ..add(DiagnosticsProperty<NoticeEntity?>('notice', notice))
      ..add(
        ObjectFlagProperty<Future<void> Function(NoticeEntity)>.has(
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

class NoticeDetailBody extends StatelessWidget {
  const NoticeDetailBody({
    required this.isLoading,
    required this.notice,
    super.key,
  });

  final NoticeEntity? notice;
  final bool isLoading;

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: isLoading || notice == null
          ? const _LoadingView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                _NoticeHeader(notice: notice!),
                if (notice?.description != null)
                  _NoticeContent(description: notice!.description!),
                if (notice?.typeInfo != null)
                  _NoticeTypeInfo(typeInfo: notice!.typeInfo!),
                _NoticeMetadata(notice: notice!),
              ],
            ),
    ),
  );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<NoticeEntity>('notice', notice))
      ..add(DiagnosticsProperty<bool>('isLoading', isLoading));
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
        CircularProgressIndicator.adaptive(),
        Text('Carregando detalhes...'),
      ],
    ),
  );
}

class _NoticeHeader extends StatelessWidget {
  const _NoticeHeader({required this.notice});

  final NoticeEntity notice;

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
              children: [
                Expanded(
                  child: Text(
                    notice.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            _NoticeTypeChip(type: notice.noticeType),
            NoticeStatusChip(status: notice.status),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<NoticeEntity>('notice', notice));
  }
}

class _NoticeTypeChip extends StatelessWidget {
  const _NoticeTypeChip({required this.type});

  final NoticeType type;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Chip(
      avatar: Icon(_icon, size: 18),
      label: Text(_label),
      backgroundColor: theme.colorScheme.onSecondaryContainer.withAlpha(26),
      labelStyle: TextStyle(
        color: theme.colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  IconData get _icon => switch (type) {
    NoticeType.communication => Icons.notifications,
    NoticeType.delivery => Icons.local_shipping,
    NoticeType.visitor => Icons.person,
    NoticeType.maintenance => Icons.build,
  };

  String get _label => switch (type) {
    NoticeType.communication => 'Comunicação',
    NoticeType.delivery => 'Entrega',
    NoticeType.visitor => 'Visitante',
    NoticeType.maintenance => 'Manutençao',
  };

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<NoticeType>('type', type));
  }
}

class _NoticeContent extends StatelessWidget {
  const _NoticeContent({required this.description});

  final String description;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            Text(
              'Descrição',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(description, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('description', description));
  }
}

class _NoticeTypeInfo extends StatelessWidget {
  const _NoticeTypeInfo({required this.typeInfo});

  final String typeInfo;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            Text(
              'Categoria',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
            ),
            Text(typeInfo, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('typeInfo', typeInfo));
  }
}

class _NoticeMetadata extends StatelessWidget {
  const _NoticeMetadata({required this.notice});

  final NoticeEntity notice;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            Text(
              'Informações',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: .bold),
            ),
            _InfoRow(
              icon: Icons.apartment,
              label: 'Id do Apartamento',
              value: notice.apartmentId.toString(),
            ),
            _InfoRow(
              icon: Icons.person,
              label: 'Criado por',
              value: 'Usuario: ${notice.creatorId}',
            ),
            if (notice.createdAt != null)
              _InfoRow(
                icon: Icons.calendar_today,
                label: 'Criado em',
                value: dateFormat.format(notice.createdAt!),
              ),
            if (notice.updatedAt != null)
              _InfoRow(
                icon: Icons.update,
                label: 'Atualizado em',
                value: dateFormat.format(notice.updatedAt!),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<NoticeEntity>('notice', notice));
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
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
