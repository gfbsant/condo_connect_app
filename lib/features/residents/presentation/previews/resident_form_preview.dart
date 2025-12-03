import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../pages/resident_form_page.dart';

@Preview(group: 'Resident Form')
Widget residentFormPreview() => PreviewWrapper(
  appBar: const ResidentFormAppBar(isEditing: false),
  body: ResidentFormBody(
    formKey: GlobalKey<FormState>(),
    emailController: TextEditingController(),
    userName: 'José Alves Oliveira',
    isOwner: true,
    isLoading: false,
    isEditing: false,
    onOwnerChanged: (final value) {},
    onSubmit: () async {},
  ),
);
