import 'notification_settings.dart';
import 'package:flutter/material.dart';

enum DashboardViewType { grid, list, compact }

class UserPreferences {
  UserPreferences({
    required this.userId,
    final DateTime? lastUpdated,
    final List<String>? dashboardOrder,
    this.themeMode = ThemeMode.system,
    this.language = 'pt_BR',
    this.showNotificationBadges = true,
    this.enableSounds = true,
    this.dashboardViewType = DashboardViewType.grid,
    this.itemsPerRow = 2,
    this.hiddenItems = const {},
    this.notificationSettings = const NotificationSettings(),
  })  : lastUpdated = lastUpdated ?? DateTime.now(),
        dashboardOrder = dashboardOrder ?? const [];

  factory UserPreferences.fromJson(final Map<String, dynamic> json) =>
      UserPreferences(
        userId: json['userId'] as String,
        lastUpdated: json['lastUpdated'] != null
            ? DateTime.parse(json['lastUpdated'] as String)
            : DateTime.now(),
        dashboardOrder:
            List<String>.from(json['dashboardOrder'] as List? ?? []),
        themeMode: ThemeMode.values.firstWhere(
          (final mode) =>
              mode.name == (json['themeMode'] as String? ?? 'system'),
          orElse: () => ThemeMode.system,
        ),
        language: json['language'] as String? ?? 'pt_BR',
        showNotificationBadges: json['showNotificationBadges'] as bool? ?? true,
        enableSounds: json['enableSounds'] as bool? ?? true,
        dashboardViewType: DashboardViewType.values.firstWhere(
          (final type) =>
              type.name == (json['dashboardViewType'] as String? ?? 'grid'),
          orElse: () => DashboardViewType.grid,
        ),
        itemsPerRow: json['itemsPerRow'] as int? ?? 2,
        hiddenItems: Map<String, bool>.from(json['hiddenItems'] as Map? ?? {}),
        notificationSettings: NotificationSettings.fromJson(
          json['notificationSettings'] as Map<String, dynamic>? ?? {},
        ),
      );
  final String userId;
  final DateTime lastUpdated;
  final List<String> dashboardOrder;
  final ThemeMode themeMode;
  final String language;
  final bool showNotificationBadges;
  final bool enableSounds;
  final DashboardViewType dashboardViewType;
  final int itemsPerRow;
  final Map<String, bool> hiddenItems;
  final NotificationSettings notificationSettings;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'lastUpdated': lastUpdated.toIso8601String(),
        'dashboardOrder': dashboardOrder,
        'themeMode': themeMode.name,
        'language': language,
        'showNotificationBadges': showNotificationBadges,
        'enableSounds': enableSounds,
        'dashboardViewType': dashboardViewType.name,
        'itemsPerRow': itemsPerRow,
        'hiddenItems': hiddenItems,
        'notificationSettings': notificationSettings.toJson(),
      };

  UserPreferences copyWith({
    final String? userId,
    final DateTime? lastUpdated,
    final List<String>? dashboardOrder,
    final ThemeMode? themeMode,
    final String? language,
    final bool? showNotificationBadges,
    final bool? enableSounds,
    final DashboardViewType? dashboardViewType,
    final int? itemsPerRow,
    final Map<String, bool>? hiddenItems,
    final NotificationSettings? notificationSettings,
  }) =>
      UserPreferences(
        userId: userId ?? this.userId,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        dashboardOrder: dashboardOrder ?? this.dashboardOrder,
        themeMode: themeMode ?? this.themeMode,
        language: language ?? this.language,
        showNotificationBadges:
            showNotificationBadges ?? this.showNotificationBadges,
        enableSounds: enableSounds ?? this.enableSounds,
        dashboardViewType: dashboardViewType ?? this.dashboardViewType,
        itemsPerRow: itemsPerRow ?? this.itemsPerRow,
        notificationSettings: notificationSettings ?? this.notificationSettings,
      );
}
