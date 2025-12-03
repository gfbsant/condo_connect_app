import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../pages/apartment_form_page.dart';

final _doorController = TextEditingController();
final _floorController = TextEditingController();
final _numberController = TextEditingController();
final _towerController = TextEditingController();
final _formKey = GlobalKey<FormState>();

void _onRentedChanged(final bool? value) {}

Future<void> _onSubmit() async {}

@Preview(group: 'Apartment Form')
Widget apartmentFormPreview() => SizedBox(
  width: 375,
  height: 667,
  child: Scaffold(
    appBar: const ApartmentFormAppBar(isEditing: false),
    body: ApartmentFormBody(
      doorController: _doorController,
      floorController: _floorController,
      formKey: _formKey,
      isEditing: false,
      isLoading: false,
      isRented: false,
      numberController: _numberController,
      onRentedChanged: _onRentedChanged,
      onSubmit: _onSubmit,
      towerController: _towerController,
    ),
  ),
);
