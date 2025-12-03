import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../shared/previews/preview_wrapper.dart';
import '../../domain/entities/condominium_entity.dart';
import '../pages/condo_search_view.dart';

final condos = List<CondominiumEntity>.generate(5, (final index) {
  final int value = index + 1;

  return CondominiumEntity(
    id: value,
    name: 'Condomínio ${Random().nextInt(10) + 1}',
    city: 'Cidade ${Random().nextInt(10)}',
    state: 'Estado ${Random().nextInt(10)}',
    neighborhood: 'Bairro ${Random().nextInt(10)}',
    zipcode: Random().nextInt(1000).toString(),
    address: 'Rua ${Random().nextInt(1000)}',
    number: Random().nextInt(1000).toString(),
  );
});

@Preview(group: 'Condo Search')
Widget condoSearchPreview() => PreviewWrapper(
  appBar: const CondoSearchAppBar(),
  body: CondoSearchBody(
    searchController: TextEditingController(),
    condos: condos,
    isSearching: false,
    isLoading: false,
    searchCallback: () async {},
    detailsCallback: (final int) async {},
  ),
);
