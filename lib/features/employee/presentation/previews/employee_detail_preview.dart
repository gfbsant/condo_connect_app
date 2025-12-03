import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/employee_entity.dart';
import '../pages/employee_detail_page.dart';

Future<void> _emptyCallback() async {}

Future<void> _editPlaceholder(final EmployeeEntity? employee) async {}

const _employee = EmployeeEntity(
  id: 5,
  userId: 4,
  condominiumId: 5,
  role: .colaborator,
  user: UserEntity(
    email: 'jose_alves@email.com',
    name: 'José Porteiro',
    cpf: '32948725879',
    birthDate: '10/11/1970',
    password: 'pass',
  ),
);

@Preview(group: 'Employee Detail')
Widget employeeDetailPreview() => const PreviewWrapper(
  appBar: EmployeeDetailAppBar(
    employee: _employee,
    editCallback: _editPlaceholder,
    deleteCallback: _emptyCallback,
  ),
  body: EmployeeDetailBody(employee: _employee, isLoading: false),
);
