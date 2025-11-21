import 'package:equatable/equatable.dart';

import '../../model/dashboard_item.dart';

enum DashboardStatus { initial, loading, success, error }

class DashboardState extends Equatable {
  const DashboardState({
    required this.status,
    required this.dashboardItems,
    required this.welcomeMessage,
    required this.roleDisplayName,
    required this.pendingCounts,
    this.errorMessage,
  });

  const DashboardState.initial()
    : status = DashboardStatus.initial,
      dashboardItems = const [],
      welcomeMessage = 'Bem-vindo!',
      roleDisplayName = '',
      pendingCounts = const {},
      errorMessage = null;

  final DashboardStatus status;
  final List<DashboardItem> dashboardItems;
  final String welcomeMessage;
  final String roleDisplayName;
  final Map<String, int> pendingCounts;
  final String? errorMessage;

  DashboardState copyWith({
    final DashboardStatus? status,
    final List<DashboardItem>? dashboardItems,
    final String? welcomeMessage,
    final String? roleDisplayName,
    final Map<String, int>? pendingCounts,
    final String? errorMessage,
    final bool clearError = false,
  }) => DashboardState(
    status: status ?? this.status,
    dashboardItems: dashboardItems ?? this.dashboardItems,
    welcomeMessage: welcomeMessage ?? this.welcomeMessage,
    roleDisplayName: roleDisplayName ?? this.roleDisplayName,
    pendingCounts: pendingCounts ?? this.pendingCounts,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    status,
    dashboardItems,
    welcomeMessage,
    roleDisplayName,
    pendingCounts,
    errorMessage,
  ];
}
