import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../domain/entities/reservation_entity.dart';
import '../pages/reservation_list_page.dart';

Future<void> _emptyCallback() async {}

Future<void> _deleteCallback(_) async {}

@Preview(group: 'Reservation List')
Widget reservationListPreview() => PreviewWrapper(
  appBar: const ReservationListAppBar(
    createAllowed: true,
    createCallback: _emptyCallback,
  ),
  body: ReservationListBody(
    reservations: List<ReservationEntity>.generate(6, (final index) {
      final int value = index + 1;
      return ReservationEntity(
        id: value,
        facilityId: value,
        apartmentId: value,
        scheduledDate: DateTime.now().add(Duration(days: value)),
      );
    }),
    deleteCallback: _deleteCallback,
    refreshCallback: _emptyCallback,
    isSearching: false,
  ),
);
