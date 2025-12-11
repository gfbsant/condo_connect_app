import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/resident_entity.dart';
import '../pages/resident_list_page.dart';

Future<void> _emptyCallback() async {}

Future<void> _detailsCallback(final int resident) async {}

const _residents = <ResidentEntity>[
  ResidentEntity(
    id: 1,
    user: UserEntity(
      email: 'maria@gmail.com',
      name: 'Maria Morgado',
      cpf: '139538593',
      birthdate: '01/10/1990',
      password: 's3832498',
    ),
    owner: true,
  ),
  ResidentEntity(
    id: 2,
    user: UserEntity(
      email: 'joao@gmail.com',
      name: 'Joao Oliveira',
      cpf: '139538593',
      birthdate: '01/10/1990',
      password: 's3832498',
    ),
    owner: false,
  ),
  ResidentEntity(
    id: 3,
    user: UserEntity(
      email: 'gabriel@gmail.com',
      name: 'Gabriel Carvalho',
      cpf: '139538593',
      birthdate: '01/10/1990',
      password: 's3832498',
    ),
    owner: false,
  ),
  ResidentEntity(
    id: 4,
    user: UserEntity(
      email: 'julia@gmail.com',
      name: 'Julia Onofre',
      cpf: '139538593',
      birthdate: '01/10/1990',
      password: 's3832498',
    ),
    owner: false,
  ),
];

@Preview(group: 'Resident List')
Widget residentListPreview() => const PreviewWrapper(
  appBar: ResidentListAppBar(createCallback: _emptyCallback),
  body: ResidentListBody(
    residents: _residents,
    detailsCallback: _detailsCallback,
    refreshCallback: _emptyCallback,
    isSearching: false,
  ),
);
