class Session {
  const Session({
    required this.id,
    required this.key,
    required this.expiresAt,
  });

  final String id;
  final List<int> key;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
