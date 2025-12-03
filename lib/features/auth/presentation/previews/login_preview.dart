import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../pages/login_page.dart';

Future<void> _emptyCallback() async {}

final _formKey = GlobalKey<FormState>();

final _textController = TextEditingController();

@Preview(group: 'Login')
Widget loginPreview() => PreviewWrapper(
  body: LoginPageBody(
    emailController: _textController,
    formKey: _formKey,
    isLoading: false,
    onSubmit: _emptyCallback,
    passwordController: _textController,
  ),
);
