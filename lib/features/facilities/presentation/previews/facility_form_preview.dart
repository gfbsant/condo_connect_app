import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../pages/facility_form_page.dart';

@Preview(group: 'Facility Form')
Widget facilityFormPreview() => PreviewWrapper(
  appBar: const FacilityFormAppBar(isEditing: false),
  body: FacilityFormBody(
    formKey: GlobalKey<FormState>(),
    nameController: TextEditingController(),
    descriptionController: TextEditingController(),
    taxController: TextEditingController(),
    isEditing: false,
    isLoading: false,
    onSubmit: () async {},
  ),
);
