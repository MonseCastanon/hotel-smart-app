import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_smart_app/config/services/hotel_service.dart';
import 'package:hotel_smart_app/models/room_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Provider de habitaciones (todos los pisos)
// ─────────────────────────────────────────────────────────────────────────────

/// Emite en tiempo real la lista completa de habitaciones desde Firestore.
final roomsStreamProvider = StreamProvider<List<RoomModel>>((ref) {
  final service = ref.watch(hotelServiceProvider);
  return service.watchRooms().map(_snapshotToRooms);
});

/// Emite en tiempo real habitaciones filtradas por [floor].
/// Pasa el piso como parámetro usando `.family`.
final roomsByFloorProvider =
    StreamProvider.family<List<RoomModel>, int>((ref, floor) {
  final service = ref.watch(hotelServiceProvider);
  return service.watchRoomsByFloor(floor).map(_snapshotToRooms);
});

/// Helper para convertir un QuerySnapshot a `List<RoomModel>`.
List<RoomModel> _snapshotToRooms(
    QuerySnapshot<Map<String, dynamic>> snapshot) {
  return snapshot.docs
      .map((doc) => RoomModel.fromFirestore(doc.id, doc.data()))
      .toList();
}

// ─────────────────────────────────────────────────────────────────────────────
// Estadísticas de habitaciones para el dashboard
// ─────────────────────────────────────────────────────────────────────────────

/// Modelo con los contadores del dashboard.
class RoomStats {
  final int occupied;
  final int available;
  final int dirty;
  final int maintenance;
  final int reserved;
  final int total;

  const RoomStats({
    this.occupied = 0,
    this.available = 0,
    this.dirty = 0,
    this.maintenance = 0,
    this.reserved = 0,
    this.total = 0,
  });

  /// Habitaciones que requieren atención (sucias + en limpieza)
  int get needsAttention => dirty + maintenance;

  /// Reservas próximas (reserved)
  int get upcoming => reserved;
}

/// Emite estadísticas de habitaciones calculadas en tiempo real.
final roomStatsProvider = StreamProvider<RoomStats>((ref) {
  final service = ref.watch(hotelServiceProvider);
  return service.watchRooms().map((snapshot) {
    final rooms = _snapshotToRooms(snapshot);
    return RoomStats(
      occupied: rooms.where((r) => r.estado == RoomStatus.occupied).length,
      available: rooms.where((r) => r.estado == RoomStatus.available).length,
      dirty: rooms.where((r) => r.estado == RoomStatus.dirty).length,
      maintenance:
          rooms.where((r) => r.estado == RoomStatus.maintenance).length,
      reserved: rooms.where((r) => r.estado == RoomStatus.reserved).length,
      total: rooms.length,
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// Pisos disponibles (calculado dinámicamente desde Firestore)
// ─────────────────────────────────────────────────────────────────────────────

/// Lista de pisos únicos disponibles, ordenados ascendentemente.
final availableFloorsProvider = StreamProvider<List<int>>((ref) {
  final service = ref.watch(hotelServiceProvider);
  return service.watchRooms().map((snapshot) {
    final rooms = _snapshotToRooms(snapshot);
    final floors = rooms.map((r) => r.piso).toSet().toList();
    floors.sort();
    return floors;
  });
});
