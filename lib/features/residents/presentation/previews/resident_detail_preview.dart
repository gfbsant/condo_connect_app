import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../domain/entities/resident_entity.dart';
import '../pages/resident_detail_page.dart';

Future<void> _emptyCallback() async {}

Future<void> editCallback(final ResidentEntity? value) async {}

const _resident = ResidentEntity(id: 1, userName: 'João Morador', owner: true);

@Preview(group: 'Resident Detail')
Widget residentDetailPreview() => const PreviewWrapper(
  appBar: ResidentDetailAppBar(
    deleteCallback: _emptyCallback,
    editCallback: editCallback,
    resident: _resident,
  ),
  body: ResidentDetailBody(isLoading: false, resident: _resident),
);
