import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../domain/entities/facility_entity.dart';
import '../pages/facility_list_page.dart';

Future<void> _emptyCallback() async {}

final _facilities = List<FacilityEntity>.generate(5, (final index) {
  final int value = index + 1;
  return FacilityEntity(
    id: value,
    name: 'Área Comum $value',
    description: '#$value',
    schedulable: true,
    tax: value * 100,
  );
});

@Preview(group: 'Facility List')
Widget facilityListPreview() => PreviewWrapper(
  appBar: const FacilityListAppBar(
    createCallback: _emptyCallback,
    createAllowed: true,
  ),
  body: FacilityListBody(
    facilities: _facilities,
    detailsCallback: (final value) async {},
    refreshCallback: _emptyCallback,
    isSearching: false,
  ),
);
