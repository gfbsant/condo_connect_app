import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/dashboard_item.dart';

class DashboardItemCard extends StatelessWidget {
  const DashboardItemCard({
    required this.item,
    required this.onTap,
    super.key,
    this.isReorderMode = false,
  });
  final DashboardItem item;
  final VoidCallback onTap;
  final bool isReorderMode;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 160,
      child: Card(
        elevation: 2,
        shadowColor: item.color.withAlpha(51),
        child: InkWell(
          onTap: item.isEnabled && !isReorderMode ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: item.color.withAlpha(51)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.color.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item.icon, color: item.color, size: 24),
                    ),
                    const Spacer(),
                    if (item.badgeCount != null && item.badgeCount! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.badgeCount! > 99
                              ? '99+'
                              : item.badgeCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (isReorderMode)
                      Icon(
                        Icons.drag_handle,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: item.isEnabled
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withAlpha(128),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: item.isEnabled
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.onSurfaceVariant.withAlpha(128),
                  ),
                ),
              ],
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
      ..add(DiagnosticsProperty<DashboardItem>('item', item))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap))
      ..add(DiagnosticsProperty<bool>('isReorderMode', isReorderMode));
  }
}
