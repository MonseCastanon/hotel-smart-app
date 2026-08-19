class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String relatedRoom;
  final String time;
  final bool active;

  const NotificationModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.relatedRoom,
    required this.time,
    this.active = true,
  });

  /// Crea un [NotificationModel] desde un documento Firestore.
  factory NotificationModel.fromFirestore(String docId, Map<String, dynamic> data) {
    final createdAt = _parseDate(data['createdAt']);
    final time = _formatDate(createdAt);

    final roomId = data['roomId']?.toString() ?? data['relatedRoom']?.toString() ?? '';
    final relatedRoom = roomId.isNotEmpty ? 'Hab. $roomId' : 'General';

    return NotificationModel(
      id: docId,
      title: data['title'] as String? ?? data['message'] as String? ?? 'Notificación',
      description: data['description'] as String? ?? data['body'] as String? ?? '',
      relatedRoom: relatedRoom,
      time: time,
      active: data['active'] as bool? ?? true,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  static String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min.';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    return '${dt.day}/${dt.month}';
  }
}
