import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_status.dart';
import '../../domain/enums/notice_type.dart';
import '../pages/notice_detail_page.dart';

@Preview(group: 'Notice Detail')
Widget noticeDetailBodyPreview() => const NoticeDetailBody(
  notice: NoticeEntity(
    title: 'Mudanca Aviso',
    description: 'Aviso de testes',
    noticeType: NoticeType.communication,
    typeInfo: 'Tipo Teste',
    status: NoticeStatus.pending,
    apartmentId: 8,
    creatorId: 3,
  ),
);
