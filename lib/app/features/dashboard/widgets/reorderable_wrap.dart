import 'package:flutter/material.dart';

class ReorderableWrap extends StatelessWidget {
  final List<Widget> children;
  final Function(int, int) onReorder;
  final double spacing;
  final double runSpacing;

  const ReorderableWrap({
    super.key,
    required this.children,
    required this.onReorder,
    this.spacing = 0,
    this.runSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: onReorder,
      children: children,
    );
  }
}
