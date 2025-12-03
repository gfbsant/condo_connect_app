import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../domain/entities/resident_entity.dart';
import '../pages/resident_list_page.dart';

Future<void> _emptyCallback() async {}

Future<void> _detailsCallback(final int resident) async {}

const _residents = <ResidentEntity>[
  ResidentEntity(id: 1, userName: 'João Silva', owner: true),
  ResidentEntity(id: 2, userName: 'Maria Santos', owner: false),
  ResidentEntity(id: 3, userName: 'Pedro Costa', owner: false),
  ResidentEntity(id: 4, userName: 'Ana Oliveira', owner: false),
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
