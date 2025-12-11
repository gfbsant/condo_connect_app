import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/resident_entity.dart';
import '../pages/resident_detail_page.dart';

Future<void> _emptyCallback() async {}

Future<void> editCallback(final ResidentEntity? value) async {}

const _resident = ResidentEntity(
  id: 1,
  user: UserEntity(
    email: 'joao@gmail.com',
    name: 'João Morado',
    cpf: '139538593',
    birthdate: '01/10/1990',
    password: 's3832498',
  ),
  owner: true,
);

@Preview(group: 'Resident Detail')
Widget residentDetailPreview() => const PreviewWrapper(
  appBar: ResidentDetailAppBar(
    deleteCallback: _emptyCallback,
    editCallback: editCallback,
    resident: _resident,
  ),
  body: ResidentDetailBody(isLoading: false, resident: _resident),
);
