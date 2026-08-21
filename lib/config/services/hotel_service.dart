import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Servicio principal de datos de la Smart TV.
///
/// Se conecta a la misma instancia de Firebase / Firestore que usa
/// [hotel_app], por lo que cualquier cambio realizado desde la app móvil
/// se refleja en tiempo real en la pantalla Smart TV gracias a los
/// [Stream]s de Firestore.
///
/// Colecciones utilizadas:
///   • `tasks`         → tareas del personal (Kanban)
///   • `notifications` → alertas activas
///
/// Nota: La colección `rooms` ya no se consulta desde esta app.
/// El monitoreo de habitaciones fue removido para enfocar la pantalla
/// 100% en el flujo de tareas y alertas del personal.
class HotelService {
  HotelService(this._firestore);

  final FirebaseFirestore _firestore;

  // ─────────────────────────────────────────────────────────────────────────
  // Colecciones
  // ─────────────────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _tasks =>
      _firestore.collection('tasks');

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection('alerts');

  // ─────────────────────────────────────────────────────────────────────────
  // Tareas — Tablero Kanban
  // ─────────────────────────────────────────────────────────────────────────

  /// Stream de tareas pendientes (`status == 'pending'`).
  /// Ordenadas por fecha de creación descendente.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchPendingTasks() =>
      _tasks
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .snapshots();

  /// Stream de tareas en progreso (`status == 'inProgress'`).
  /// Usa camelCase para coincidir con WearTaskStatus.inProgress.name del wear-app.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchInProgressTasks() =>
      _tasks
          .where('status', isEqualTo: 'inProgress')
          .orderBy('createdAt', descending: true)
          .snapshots();

  /// Stream de las últimas [limit] tareas NO completadas.
  /// Usa 'inProgress' (camelCase) para coincidir con WearTaskStatus.inProgress.name.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchActiveTasks({
    int limit = 20,
  }) =>
      _tasks
          .where('status', whereIn: ['pending', 'inProgress'])
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots();

  // ─────────────────────────────────────────────────────────────────────────
  // Notificaciones / Alertas
  // ─────────────────────────────────────────────────────────────────────────

  /// Stream de notificaciones activas (campo `isAcknowledged == false`).
  /// Limitado a 10 resultados para evitar desbordamiento visual.
  /// Ordenado por fecha de creación descendente.
  ///
  /// NOTA: El filtro `isAcknowledged` se aplica en cliente para evitar requerir
  /// un índice compuesto en Firestore (isAcknowledged + createdAt).
  Stream<QuerySnapshot<Map<String, dynamic>>> watchActiveNotifications() =>
      _notifications
          .orderBy('createdAt', descending: true)
          .limit(30) // Carga más y filtra en cliente
          .snapshots();
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers (Riverpod)
// ─────────────────────────────────────────────────────────────────────────────

/// Provider de la instancia de [FirebaseFirestore].
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

/// Provider del [HotelService].
/// Inyecta [firestoreProvider] para que el servicio sea testeable.
final hotelServiceProvider = Provider<HotelService>(
  (ref) => HotelService(ref.watch(firestoreProvider)),
);
