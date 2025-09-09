import 'package:flutter/widgets.dart';

class DashboardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
  final int? badgeCount;
  final bool isEnabled;

  const DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
    this.badgeCount,
    this.isEnabled = true,
  });

  DashboardItem copyWith(
      {String? title,
      String? subtitle,
      IconData? icon,
      Color? color,
      String? route,
      int? badgeCount,
      bool? isEnabled}) {
    return DashboardItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      route: route ?? this.route,
      badgeCount: badgeCount ?? this.badgeCount,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
