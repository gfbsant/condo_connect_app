import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_status.dart';
import '../../domain/enums/notice_type.dart';
import '../pages/notice_detail_page.dart';

Future<void> _emptyCallback() async {}

Future<void> _editCallback(final NoticeEntity? notice) async {}

@Preview(group: 'Notice Detail')
Widget noticeDetailBodyPreview() => const SizedBox(
  width: 375,
  height: 667,
  child: Scaffold(
    appBar: NoticeDetailAppBar(
      deleteCallback: _emptyCallback,
      editCallback: _editCallback,
    ),
    body: NoticeDetailBody(
      isLoading: false,
      notice: NoticeEntity(
        title: 'Problema no interfone',
        description: 'Prestadores de serviço precisam trocar o interfone',
        noticeType: NoticeType.communication,
        typeInfo: 'Manutenção',
        status: NoticeStatus.pending,
        apartmentId: 8,
        creatorId: 3,
      ),
    ),
  ),
);
