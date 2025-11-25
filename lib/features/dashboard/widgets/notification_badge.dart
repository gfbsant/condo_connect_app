import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    required this.count,
    required this.onTap,
    super.key,
  });
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => IconButton(
    onPressed: onTap,
    icon: Stack(
      children: [
        const Icon(Icons.notifications_outlined),
        if (count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
      ..add(IntProperty('count', count))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }
}
