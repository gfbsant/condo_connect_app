import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../pages/employee_form_page.dart';

final _textController = TextEditingController();

@Preview(group: 'Employee Form')
Widget employeeFormPreview() => PreviewWrapper(
  appBar: const EmployeeFormAppBar(isEditing: false),
  body: EmployeeFormBody(
    formKey: GlobalKey<FormState>(),
    descriptionController: _textController,
    userIdContoller: _textController,
    selectedRole: .admin,
    isLoading: false,
    isEditing: false,
    onUpdateRole: (final role) {},
    onSubmit: () async {},
  ),
);
