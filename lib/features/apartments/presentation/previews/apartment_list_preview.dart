import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../residents/domain/entities/resident_entity.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/apartment_entity.dart';
import '../pages/apartment_list_page.dart';

Future<void> _emptyCallback() async {}

Future<void> _detailsCallbackPlaceholder(final int value) async {}

final _residents = List<ResidentEntity>.generate(
  4,
  (final index) => ResidentEntity(
    id: index,
    user: const UserEntity(
      email: 'john.doe@example.com',
      name: 'John Doe',
      cpf: '123.456.789-00',
      birthdate: '1990-01-01',
      password: 'password123',
    ),
    owner: index.isEven,
  ),
);

final _apartments = <ApartmentEntity>[
  ApartmentEntity(
    id: 1,
    number: '402',
    tower: '8',
    floor: 4,
    active: true,
    rented: true,
    residents: _residents,
  ),
  ApartmentEntity(
    id: 3,
    number: '301',
    tower: '2',
    floor: 3,
    active: false,
    rented: false,
    residents: _residents.take(2).toList(),
  ),
  ApartmentEntity(
    id: 2,
    number: '204',
    tower: '11',
    floor: 2,
    active: true,
    rented: false,
    residents: _residents.take(3).toList(),
  ),
  ApartmentEntity(
    id: 2,
    number: '204',
    tower: '11',
    floor: 2,
    active: true,
    rented: false,
    residents: List.of([_residents.first]),
  ),
];

@Preview(group: 'Apartments List')
Widget apartmentListPreview() => SizedBox(
  width: 375,
  height: 667,
  child: Scaffold(
    appBar: const ApartmentListAppBar(createCallback: _emptyCallback),
    body: ApartmentListBody(
      apartments: _apartments,
      detailsCallback: _detailsCallbackPlaceholder,
      refreshCallback: _emptyCallback,
      isSearching: false,
    ),
  ),
);
