import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/employee_entity.dart';
import '../pages/employee_list_page.dart';

Future<void> _emptyCallback() async {}

Future<void> _detailsCallback(final int value) async {}

final _employees = List<EmployeeEntity>.generate(8, (final index) {
  final int randomValue = Random().nextInt(101);
  return EmployeeEntity(
    userId: index + 1,
    condominiumId: index + 1,
    role: index.isEven ? .admin : .collaborator,
    user: UserEntity(
      email: 'email$randomValue@email.com',
      name: 'Funcionário $randomValue',
      cpf: randomValue.toString(),
      birthdate: '$index/$randomValue/$randomValue',
      password: 'pass',
    ),
  );
});

@Preview(group: 'Employee List')
Widget employeeListPreview() => PreviewWrapper(
  appBar: const EmployeeListAppBar(createCallback: _emptyCallback),
  body: EmployeeListBody(
    employees: _employees,
    isSearching: false,
    detailsCallback: _detailsCallback,
    refreshCallback: _emptyCallback,
  ),
);
