import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../residents/domain/entities/resident_entity.dart';
import '../../domain/entities/apartment_entity.dart';
import '../pages/apartment_detail_page.dart';

Future<void> _emptyCallback() async {}

Future<void> _placeholderCallbackForApartment(
  final ApartmentEntity? apartment,
) async {}

const _residents = <ResidentEntity>[
  ResidentEntity(id: 1, userName: 'Resident 1', owner: true),
  ResidentEntity(id: 2, userName: 'RserName', owner: false),
];

const _apartment = ApartmentEntity(
  number: '200',
  condominiumId: 5,
  tower: '11',
  floor: '4',
  door: 'B',
  active: true,
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
    ),
  ),
);
