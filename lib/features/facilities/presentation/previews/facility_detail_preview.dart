import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../domain/entities/facility_entity.dart';
import '../pages/facility_detail_page.dart';

const _facility = FacilityEntity(
  id: 2,
  name: 'Salão de Festas',
  description: 'Disponível das 12 as 22 horas',
  tax: 250,
);

Future<void> _emptyCallback() async {}

Future<void> _emptyCallbackWithParam(_) async {}

@Preview(group: 'Facility Detail')
Widget facilityDetailPreview() => const PreviewWrapper(
  appBar: FacilityDetailAppBar(
    facility: _facility,
    editCallback: _emptyCallbackWithParam,
    deleteCallback: _emptyCallback,
  ),
  body: FacilityDetailBody(
    facility: _facility,
    isLoading: false,
    onRefresh: _emptyCallback,
    reservationsCallback: _emptyCallbackWithParam,
  ),
);
