import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../pages/notice_form_page.dart';

@Preview(group: 'Notice Form')
Widget noticeFormPreview() => PreviewWrapper(
  appBar: const NoticeFormAppBar(isEditing: false),
  body: NoticeFormBody(
    formKey: GlobalKey<FormState>(),
    titleController: TextEditingController(),
    descriptionController: TextEditingController(),
    typeInfoController: TextEditingController(),
    selectedType: .delivery,
    selectedStatus: .pending,
    isLoading: false,
    isEditing: false,
    onTypeChange: (final type) {},
    onStatusChange: (final status) {},
    onSubmit: () async {},
  ),
);
