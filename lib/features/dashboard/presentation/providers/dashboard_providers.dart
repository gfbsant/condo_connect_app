import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/dashboard_item.dart';
import 'dashboard_notifier.dart';
import 'dashboard_state.dart';

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

final dashboardNotifierAccessor = Provider<DashboardNotifier>(
  (final ref) => ref.watch(dashboardNotifierProvider.notifier),
);

final isLoadingProvider = Provider<bool>(
  (final ref) =>
      ref.watch(dashboardNotifierProvider).status == DashboardStatus.loading,
);

final dashboardItemsProvider = Provider<List<DashboardItem>>(
  (final ref) => ref.watch(dashboardNotifierProvider).dashboardItems,
);

final welcomeMessageProvider = Provider<String>(
  (final ref) => ref.watch(dashboardNotifierProvider).welcomeMessage,
);

final roleDisplayNameProvider = Provider<String>(
  (final ref) => ref.watch(dashboardNotifierProvider).roleDisplayName,
);

final pendingCountsProvider = Provider<Map<String, int>>(
  (final ref) => ref.watch(dashboardNotifierProvider).pendingCounts,
);

final errorMessageProvider = Provider<String?>(
  (final ref) => ref.watch(dashboardNotifierProvider).errorMessage,
);
