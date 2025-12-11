import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../residents/domain/entities/resident_entity.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/apartment_entity.dart';
import '../pages/apartment_detail_page.dart';

Future<void> _emptyCallback() async {}

Future<void> _placeholderCallbackForApartment(
  final ApartmentEntity? apartment,
) async {}

const _residents = <ResidentEntity>[
  ResidentEntity(
    id: 1,
    user: UserEntity(
      email: 'john.doe@example.com',
      name: 'John Doe',
      cpf: '123.456.789-00',
      birthdate: '1990-01-01',
      password: 'password123',
    ),
    owner: true,
  ),
  ResidentEntity(
    id: 2,
    user: UserEntity(
      email: 'jane.smith@example.com',
      name: 'Jane Smith',
      cpf: '987.654.321-00',
      birthdate: '1985-05-15',
      password: 'password456',
    ),
    owner: false,
  ),
];

const _apartment = ApartmentEntity(
  number: '200',
  tower: '11',
  floor: 4,
  door: 'B',
  active: false,
  rented: true,
  residents: _residents,
);

@Preview(group: 'Apartment Detail')
Widget apartmentDetailPreview() => const SizedBox(
  width: 375,
  height: 667,
  child: Scaffold(
    appBar: ApartmentDetailAppBar(
      approveCallback: _emptyCallback,
      deleteCallback: _emptyCallback,
      editCallback: _placeholderCallbackForApartment,
      isApproving: false,
      apartment: _apartment,
    ),
    body: ApartmentDetailBody(
      apartment: _apartment,
      isLoading: false,
      residentsCallback: _placeholderCallbackForApartment,
      reservationsCallback: _placeholderCallbackForApartment,
      noticesCallback: _placeholderCallbackForApartment,
    ),
  ),
);
