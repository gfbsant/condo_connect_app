enum NoticeType {
  delivery('delivery', 0),
  visitor('visitor', 1),
  maintenance('maintenance', 2),
  communication('communication', 3);

  const NoticeType(this.name, this.value);

  final String name;
  final int value;

  static NoticeType fromValue(final int value) => NoticeType.values.firstWhere(
    (final type) => type.value == value,
    orElse: () => NoticeType.communication,
  );

  static NoticeType fromString(final String name) =>
      NoticeType.values.firstWhere(
        (final type) => type.name == name,
        orElse: () => NoticeType.communication,
      );
}
