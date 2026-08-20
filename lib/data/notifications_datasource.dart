import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

/// Fuente de datos de notificaciones/alertas para la Smart TV.
///
/// Conecta con la colección `notifications` de Firestore en tiempo real.
/// Limita a 10 resultados y ordena por fecha descendente para evitar
/// el desbordamiento visual reportado por el profesor.
class NotificationsDatasource {
  final FirebaseFirestore _firestore;

  NotificationsDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection('notifications');

  // ─────────────────────────────────────────────────────────────────────────
  // Stream en tiempo real (Firestore)
  // ─────────────────────────────────────────────────────────────────────────

  /// Stream de alertas activas desde Firestore.
  /// Limitado a 10 documentos, ordenado por fecha descendente.
  Stream<List<NotificationModel>> watchActiveNotifications() {
    return _notifications
        .where('active', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                NotificationModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

}
