import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../pages/reset_password_page.dart';

Future<void> _emptyCallback() async {}

final _formKey = GlobalKey<FormState>();

final _textController = TextEditingController();

@Preview(group: 'Reset Password')
Widget resetPasswordPreview() => PreviewWrapper(
  appBar: const ResetPasswordAppBar(tokenStep: false),
  body: ResetPasswordBody(
    formKey: _formKey,
    emailController: _textController,
    passwordController: _textController,
    confirmPasswordController: _textController,
    tokenController: _textController,
    isLoading: false,
    isTokenStep: false,
    requestResetCallback: _emptyCallback,
    confirmResetCallback: _emptyCallback,
    returnCallback: _emptyCallback,
  ),
);
