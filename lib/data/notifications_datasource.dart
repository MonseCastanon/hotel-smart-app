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

  // ─────────────────────────────────────────────────────────────────────────
  // Datos dummy (fallback cuando Firestore está vacío)
  // ─────────────────────────────────────────────────────────────────────────

  /// Alertas de ejemplo para visualización.
  static List<NotificationModel> getDummyNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: 'notif-1',
        title: 'Limpieza Urgente',
        description: 'El huésped de la 801 solicita limpieza inmediata.',
        relatedRoom: 'Hab. 801',
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      NotificationModel(
        id: 'notif-2',
        title: 'Mantenimiento A/C',
        description: 'Aire acondicionado reportado como defectuoso.',
        relatedRoom: 'Hab. 302',
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
      NotificationModel(
        id: 'notif-3',
        title: 'Check-out Atrasado',
        description: 'El huésped no ha realizado check-out a tiempo.',
        relatedRoom: 'Hab. 505',
        createdAt: now.subtract(const Duration(minutes: 45)),
      ),
      NotificationModel(
        id: 'notif-4',
        title: 'Suministros Bajos',
        description: 'Piso 4 reporta falta de amenidades de baño.',
        relatedRoom: 'Piso 4',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }
}
