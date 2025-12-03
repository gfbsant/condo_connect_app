import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../pages/register_page.dart';

Future<void> _emptyCallback() async {}

final _formKey = GlobalKey<FormState>();

final _textController = TextEditingController();

@Preview(group: 'Register Page')
Widget registerPagePreview() => PreviewWrapper(
  appBar: const RegisterPageAppBar(),
  body: RegisterPageBody(
    formKey: _formKey,
    birthDateController: _textController,
    confirmPasswordController: _textController,
    cpfController: _textController,
    emailController: _textController,
    isLoading: false,
    nameController: _textController,
    passwordController: _textController,
    phoneController: _textController,
    onSubmit: _emptyCallback,
  ),
);
