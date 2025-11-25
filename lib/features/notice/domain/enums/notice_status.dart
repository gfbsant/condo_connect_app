enum NoticeStatus {
  pending('pending', 0),
  acknowledged('acknowledged', 1),
  resolved('resolved', 2),
  blocked('blocked', 3);

  const NoticeStatus(this.name, this.value);

  final String name;
  final int value;

  static NoticeStatus fromValue(final int value) =>
      NoticeStatus.values.firstWhere(
        (final status) => status.value == value,
        orElse: () => NoticeStatus.pending,
      );

  static NoticeStatus fromName(final String name) =>
      NoticeStatus.values.firstWhere(
        (final status) => status.name == name,
        orElse: () => NoticeStatus.pending,
      );

  bool canTransitionTo(final NoticeStatus newStatus) {
    const Map<NoticeStatus, List<NoticeStatus>> allowedTransitions = {
      NoticeStatus.pending: [
        NoticeStatus.acknowledged,
        NoticeStatus.resolved,
        NoticeStatus.blocked,
      ],
      NoticeStatus.acknowledged: [NoticeStatus.resolved, NoticeStatus.blocked],
      NoticeStatus.resolved: <NoticeStatus>[],
      NoticeStatus.blocked: [NoticeStatus.resolved],
    };
    return allowedTransitions[this]?.contains(newStatus) ?? false;
  }
}
