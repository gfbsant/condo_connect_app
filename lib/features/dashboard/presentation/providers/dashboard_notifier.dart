import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../user/domain/entities/user_entity.dart';
import 'dashboard_state.dart';

class DashboardNotifier extends Notifier<DashboardState> {
  UserEntity? get _currentUser => ref.read(currentUserProvider);

  @override
  DashboardState build() {
    ref.listen<UserEntity?>(currentUserProvider, (
      final previous,
      final next,
    ) async {
      if (next != null) {
        await _loadDashboardData();
      }
    });
    return const DashboardState.initial();
  }

  Future<void> _loadDashboardData() async {
    final UserEntity? user = _currentUser;
    if (user == null) {
      return;
    }

    state = state.copyWith(status: DashboardStatus.loading);

    try {
      state = state.copyWith();
    } on Exception catch (e) {
      log('Error loading dashboard data: $e');
      state = state.copyWith(
        status: DashboardStatus.error,
        errorMessage: 'Erro ao carregar dados do dashboard',
      );
    }
  }

  Future<void> logout() async {
    await ref.read(authNotifierAccessor).logout();
  }

  Future<void> refresh() async {
    await _loadDashboardData();
  }
}
