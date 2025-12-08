import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../pages/condo_form_page.dart';

Future<void> _emptyCallback() async {}

final _formKey = GlobalKey<FormState>();

final _textController = TextEditingController();

@Preview(group: 'Condo Form')
Widget condoFormPreview() => PreviewWrapper(
  appBar: const CondorFormAppBar(isEditing: false),
  body: CondoFormBody(
    formKey: _formKey,
    nameController: _textController,
    cityController: _textController,
    stateController: _textController,
    neighborhoodController: _textController,
    zipcodeController: _textController,
    addressController: _textController,
    numberController: _textController,
    isEditing: false,
    isLoading: false,
    onSubmit: _emptyCallback,
  ),
);
