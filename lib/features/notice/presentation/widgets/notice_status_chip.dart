import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../domain/enums/notice_status.dart';

@Preview(group: 'Notice Status Chip')
Widget noticeStatusChipPreview() => Column(
  spacing: 12,
  children: [
    ...NoticeStatus.values.map(
      (final status) => NoticeStatusChip(status: status),
    ),
  ],
);

class NoticeStatusChip extends StatelessWidget {
  const NoticeStatusChip({required this.status, super.key});

  final NoticeStatus status;

  @override
  Widget build(final BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: _color.withAlpha(26),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _color.withAlpha(51)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(_icon, size: 14, color: _color),
        Text(
          _label,
          style: TextStyle(
            color: _color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Color get _color => switch (status) {
    NoticeStatus.pending => Colors.orange,
    NoticeStatus.acknowledged => Colors.blue,
    NoticeStatus.resolved => Colors.green,
    NoticeStatus.blocked => Colors.red,
  };

  IconData get _icon => switch (status) {
    NoticeStatus.pending => Icons.schedule,
    NoticeStatus.acknowledged => Icons.autorenew,
    NoticeStatus.resolved => Icons.check_circle,
    NoticeStatus.blocked => Icons.block,
  };

  String get _label => switch (status) {
    NoticeStatus.pending => 'Pendente',
    NoticeStatus.acknowledged => 'Em Andamento',
    NoticeStatus.resolved => 'Resolvido',
    NoticeStatus.blocked => 'Bloqueado',
  };

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<NoticeStatus>('status', status));
  }
}
