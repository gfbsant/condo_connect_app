import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../pages/employee_form_page.dart';

@Preview(group: 'Employee Form')
Widget employeeFormPreview() => PreviewWrapper(
  appBar: const EmployeeFormAppBar(isEditing: false),
  body: EmployeeFormBody(
    formKey: GlobalKey<FormState>(),
    emailController: TextEditingController(),
    selectedRole: .admin,
    isLoading: false,
    isEditing: false,
    onUpdateRole: (final role) {},
    onSubmit: () async {},
  ),
);
