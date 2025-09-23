import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReorderableWrap extends StatelessWidget {
  const ReorderableWrap({
    required this.children,
    required this.onReorder,
    super.key,
    this.spacing = 0,
    this.runSpacing = 0,
  });
  final List<Widget> children;
  final Function(int, int) onReorder;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(final BuildContext context) => ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        onReorder: onReorder,
        children: children,
      );

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<Function(int p1, int p2)>.has(
        'onReorder',
        onReorder,
      ),
    );
    properties.add(DoubleProperty('spacing', spacing));
    properties.add(DoubleProperty('runSpacing', runSpacing));
  }
}
