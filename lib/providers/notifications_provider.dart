import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_smart_app/config/services/hotel_service.dart';
import 'package:hotel_smart_app/models/notification_model.dart';

// ────────────────────────────────────────────────────────────────────────────────
// Provider de notificaciones
// ────────────────────────────────────────────────────────────────────────────────

/// Stream de notificaciones activas en tiempo real desde Firestore.
/// El filtro `isAcknowledged == false` se aplica en cliente para evitar
/// requerir un índice compuesto en Firebase.
final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  final service = ref.watch(hotelServiceProvider);
  return service.watchActiveNotifications().map(_snapshotToNotifications);
});

/// Helper para convertir QuerySnapshot a `List<NotificationModel>`.
/// Filtra alertas no reconocidas y limita a 10 para evitar desbordamiento visual.
List<NotificationModel> _snapshotToNotifications(
    QuerySnapshot<Map<String, dynamic>> snapshot) {
  return snapshot.docs
      .map((doc) => NotificationModel.fromFirestore(doc.id, doc.data()))
      .where((n) => n.active) // isAcknowledged == false → active == true
      .take(10)
      .toList();
}
