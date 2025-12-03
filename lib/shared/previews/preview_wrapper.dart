import 'package:flutter/material.dart';

class PreviewWrapper extends StatelessWidget {
  const PreviewWrapper({required this.body, this.appBar, super.key});

  final PreferredSizeWidget? appBar;
  final Widget? body;

  @override
  Widget build(final BuildContext context) => SizedBox(
    width: 365,
    height: 667,
    child: Scaffold(appBar: appBar, body: body),
  );
}
