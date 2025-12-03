import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../domain/entities/notice_entity.dart';
import '../pages/notice_list_page.dart';

final _notices = List<NoticeEntity>.generate(4, (final index) {
  final int value = index + 1;
  return NoticeEntity(
    id: value,
    title: 'Aviso $value',
    description: 'Descrição do aviso $value',
    typeInfo: 'Dados adicionais do aviso $value',
    noticeType: .fromValue(index),
    status: .fromValue(index),
    apartmentId: value,
    creatorId: value,
    createdAt: DateTime.now().subtract(Duration(days: value, hours: 12)),
  );
});

@Preview(group: 'Notice List')
Widget noticeListPreview() => PreviewWrapper(
  appBar: const NoticeListAppBar(fromApartment: false),
  body: NoticeListBody(
    notices: _notices,
    isSearching: false,
    refreshCallback: () async {},
    detailsCallback: (final value) async {},
  ),
);
