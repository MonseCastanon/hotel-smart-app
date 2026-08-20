/// Modelo de notificación / alerta para la Smart TV.
///
/// Representa un documento de la colección `notifications` en Firestore.
/// Se limitan a 10 resultados ordenados por fecha descendente para
/// evitar desbordamiento visual en la pantalla.
class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String relatedRoom;
  final DateTime createdAt;
  final bool active;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.relatedRoom,
    required this.createdAt,
    this.active = true,
  });

  /// Crea un [NotificationModel] a partir de un documento de Firestore.
  factory NotificationModel.fromFirestore(
    String docId,
    Map<String, dynamic> data,
  ) {
    return NotificationModel(
      id: docId,
      title: data['title'] as String? ?? 'Alerta',
      description: data['description'] as String? ?? '',
      relatedRoom: data['relatedRoom'] as String? ?? data['room'] as String? ?? '',
      createdAt: _parseDate(data['createdAt']),
      active: data['active'] as bool? ?? true,
    );
  }

  /// Convierte el modelo a un mapa compatible con Firestore.
  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'relatedRoom': relatedRoom,
        'createdAt': createdAt.toIso8601String(),
        'active': active,
      };

  /// Helper para parsear fechas de Firestore.
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  /// Formato legible del tiempo transcurrido.
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    return '${createdAt.day}/${createdAt.month} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }
}
