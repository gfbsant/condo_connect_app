import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../../facilities/domain/entities/facility_entity.dart';
import '../pages/reservation_form_page.dart';

void _onFacilitySelectCallback(_) {}

Future<void> _emptyCallback() async {}

const _facility = FacilityEntity(id: 1, name: 'Salão de Festas');

@Preview(group: 'Reservation Form')
Widget reservationFormPreview() => PreviewWrapper(
  appBar: const ReservationFormAppBar(),
  body: ReservationFormBody(
    selectedDate: DateTime.now(),
    selectedFacility: _facility,
    facilities: const [_facility],
    isLoading: false,
    isLoadingFacilities: false,
    onFacilitySelected: _onFacilitySelectCallback,
    onDateSelect: _emptyCallback,
    onSubmit: _emptyCallback,
  ),
);
