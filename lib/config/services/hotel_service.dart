import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_smart_app/models/reservation_model.dart';

/// Servicio principal de datos de la Smart TV.
///
/// Se conecta a la misma instancia de Firebase / Firestore que usa
/// [hotel_app], por lo que cualquier cambio realizado desde la app móvil
/// se refleja en tiempo real en la pantalla Smart TV gracias a los
/// [Stream]s de Firestore.
///
/// Colecciones esperadas en Firestore:
///   • `rooms`        → documentos de habitación
///   • `reservations` → documentos de reservación
///   • `tasks`        → actividad reciente (limpieza, etc.)
///   • `notifications`→ alertas activas
class HotelService {
  HotelService(this._firestore);

  final FirebaseFirestore _firestore;

  // ─────────────────────────────────────────────────────────────────────────
  // Colecciones
  // ─────────────────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _rooms =>
      _firestore.collection('rooms');

  CollectionReference<Map<String, dynamic>> get _reservations =>
      _firestore.collection('reservations');

  CollectionReference<Map<String, dynamic>> get _tasks =>
      _firestore.collection('tasks');

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection('notifications');

  // ─────────────────────────────────────────────────────────────────────────
  // Habitaciones
  // ─────────────────────────────────────────────────────────────────────────

  /// Stream de todos los documentos de la colección `rooms`.
  /// Emite una nueva lista cada vez que algún documento cambia en Firestore.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchRooms() =>
      _rooms.orderBy('number').snapshots();

  /// Stream filtrado por [floor] (campo `floor` en Firestore).
  Stream<QuerySnapshot<Map<String, dynamic>>> watchRoomsByFloor(int floor) =>
      _rooms
          .where('floor', isEqualTo: floor)
          .orderBy('number')
          .snapshots();

  // ─────────────────────────────────────────────────────────────────────────
  // Reservaciones
  // ─────────────────────────────────────────────────────────────────────────

  /// Stream de reservaciones activas (pending o confirmed).
  Stream<QuerySnapshot<Map<String, dynamic>>> watchActiveReservations() =>
      _reservations
          .where('status', whereIn: ['pending', 'confirmed'])
          .orderBy('checkIn')
          .snapshots();

  /// Stream de reservaciones con check-in realizado (huéspedes en el hotel).
  Stream<QuerySnapshot<Map<String, dynamic>>> watchCheckedInReservations() =>
      _reservations
          .where('status', isEqualTo: ReservationStatus.checkedIn.name)
          .snapshots();

  /// Obtiene una reservación por ID una sola vez (lectura puntual).
  Future<ReservationModel?> getReservationById(String id) async {
    final doc = await _reservations.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return ReservationModel.fromFirestore(doc.id, doc.data()!);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Tareas / Actividad reciente
  // ─────────────────────────────────────────────────────────────────────────

  /// Stream de las últimas [limit] tareas, ordenadas por createdAt descendente.
  /// El campo es `createdAt` (ISO8601 string) tal como lo guarda Hotel-Project.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchRecentTasks({
    int limit = 20,
  }) =>
      _tasks.orderBy('createdAt', descending: true).limit(limit).snapshots();

  /// Stream de tareas activas (pending + inProgress) para el dashboard.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchActiveTasks() =>
      _tasks
          .where('status', whereIn: ['pending', 'inProgress'])
          .orderBy('priority', descending: true)
          .snapshots();

  // ─────────────────────────────────────────────────────────────────────────
  // Notificaciones / Alertas
  // ─────────────────────────────────────────────────────────────────────────

  /// Stream de notificaciones activas (campo `active == true`).
  Stream<QuerySnapshot<Map<String, dynamic>>> watchActiveNotifications() =>
      _notifications
          .where('active', isEqualTo: true)
          .orderBy('createdAt', descending: true)
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
