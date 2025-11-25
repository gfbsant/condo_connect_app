import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_type.dart';
import 'notice_status_chip.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({required this.notice, required this.onTap, super.key});

  final NoticeEntity notice;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yy HH:mm');
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor(context).withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _typeIcon,
                      color: _getTypeColor(context),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notice.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (notice.description != null &&
                            notice.description!.isNotEmpty)
                          Text(
                            notice.description!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              Row(
                children: [
                  NoticeStatusChip(status: notice.status),
                  const Spacer(),
                  if (notice.createdAt != null)
                    Row(
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        Text(
                          dateFormat.format(notice.createdAt!),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              if (notice.typeInfo != null && notice.typeInfo!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      Expanded(
                        child: Text(
                          notice.typeInfo!,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData get _typeIcon => switch (notice.noticeType) {
    NoticeType.communication => Icons.notifications_outlined,
    NoticeType.delivery => Icons.local_shipping_outlined,
    NoticeType.maintenance => Icons.build_outlined,
    NoticeType.visitor => Icons.person_outlined,
  };

  Color _getTypeColor(final BuildContext context) =>
      switch (notice.noticeType) {
        NoticeType.communication => Theme.of(context).colorScheme.primary,
        NoticeType.delivery => Colors.blue,
        NoticeType.maintenance => Colors.orange,
        NoticeType.visitor => Colors.green,
      };

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<NoticeEntity>('notice', notice))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}
