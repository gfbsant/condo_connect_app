import 'package:flutter/material.dart';

class NotificationSettings {
  final bool enablePushNotifications;
  final bool enableEmailNotifications;
  final List<String> mutedCategories;
  final TimeOfDay quietStart;
  final TimeOfDay quietEnd;

  const NotificationSettings({
    this.enablePushNotifications = true,
    this.enableEmailNotifications = true,
    this.mutedCategories = const [],
    this.quietStart = const TimeOfDay(hour: 22, minute: 0),
    this.quietEnd = const TimeOfDay(hour: 8, minute: 0),
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      enablePushNotifications: json['enablePushNotifications'] as bool? ?? true,
      enableEmailNotifications:
          json['enableEmailNotifications'] as bool? ?? true,
      mutedCategories:
          List<String>.from(json['mutedCategories'] as List? ?? []),
      quietStart: _timeFromJson(json['quietStart']),
      quietEnd: _timeFromJson(json['quietEnd']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enablePushNotifications': enablePushNotifications,
      'enableEmailNotifications': enableEmailNotifications,
      'mutedCategories': mutedCategories,
      'quietStart': _timeToJson(quietStart),
      'quietEnd': _timeToJson(quietEnd)
    };
  }

  static TimeOfDay _timeFromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return TimeOfDay(
          hour: json['hour'] as int? ?? 22,
          minute: json['minute'] as int? ?? 0);
    }
    return const TimeOfDay(hour: 22, minute: 0);
  }

  static Map<String, int> _timeToJson(TimeOfDay time) {
    return {'hour': time.hour, 'minute': time.minute};
  }

  NotificationSettings copyWith(
      {bool? enablePushNotifications,
      bool? enableEmailNotifications,
      List<String>? mutedCategories,
      TimeOfDay? quietStart,
      TimeOfDay? quietEnd}) {
    return NotificationSettings(
      enablePushNotifications:
          enablePushNotifications ?? this.enableEmailNotifications,
      enableEmailNotifications:
          enableEmailNotifications ?? this.enableEmailNotifications,
      mutedCategories: mutedCategories ?? this.mutedCategories,
      quietStart: quietStart ?? this.quietStart,
      quietEnd: quietEnd ?? this.quietEnd,
    );
  }
}
