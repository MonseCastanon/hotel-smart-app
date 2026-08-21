import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_smart_app/config/services/api_service.dart';
import 'package:hotel_smart_app/models/room_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Provider de habitaciones (todos los pisos)
// ─────────────────────────────────────────────────────────────────────────────

/// Emite la lista completa de habitaciones desde la API REST.
/// Hace polling cada 3 segundos para simular tiempo real.
final roomsStreamProvider = StreamProvider<List<RoomModel>>((ref) async* {
  final api = ref.watch(apiServiceProvider);
  
  while (true) {
    try {
      final rooms = await api.getRooms();
      rooms.sort((a, b) => a.numero.compareTo(b.numero));
      yield rooms;
    } catch (e) {
      // Si hay error en la primera carga, lo lanzamos.
      // Si es un error subsecuente, la UI mantendrá los datos anteriores.
      rethrow;
    }
    await Future.delayed(const Duration(seconds: 3));
  }
});

/// Emite habitaciones filtradas por [floor].
final roomsByFloorProvider =
    StreamProvider.family<List<RoomModel>, int>((ref, floor) async* {
  final api = ref.watch(apiServiceProvider);
  
  while (true) {
    try {
      final allRooms = await api.getRooms();
      final filteredRooms = allRooms.where((r) => r.piso == floor).toList();
      filteredRooms.sort((a, b) => a.numero.compareTo(b.numero));
      yield filteredRooms;
    } catch (e) {
      rethrow;
    }
    await Future.delayed(const Duration(seconds: 3));
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// Helper eliminado (ya no dependemos de Firestore Snapshot)
// ─────────────────────────────────────────────────────────────────────────────

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

/// Emite estadísticas de habitaciones calculadas.
final roomStatsProvider = StreamProvider<RoomStats>((ref) async* {
  final api = ref.watch(apiServiceProvider);
  
  while (true) {
    try {
      final rooms = await api.getRooms();
      yield RoomStats(
        occupied: rooms.where((r) => r.estado == RoomStatus.occupied).length,
        available: rooms.where((r) => r.estado == RoomStatus.available).length,
        dirty: rooms.where((r) => r.estado == RoomStatus.dirty).length,
        maintenance:
            rooms.where((r) => r.estado == RoomStatus.maintenance).length,
        reserved: rooms.where((r) => r.estado == RoomStatus.reserved).length,
        total: rooms.length,
      );
    } catch (e) {
      rethrow;
    }
    await Future.delayed(const Duration(seconds: 3));
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// Pisos disponibles (calculado dinámicamente desde Firestore)
// ─────────────────────────────────────────────────────────────────────────────

/// Lista de pisos únicos disponibles, ordenados ascendentemente.
final availableFloorsProvider = StreamProvider<List<int>>((ref) async* {
  final api = ref.watch(apiServiceProvider);
  
  while (true) {
    try {
      final rooms = await api.getRooms();
      final floors = rooms.map((r) => r.piso).toSet().toList();
      floors.sort();
      yield floors;
    } catch (e) {
      rethrow;
    }
    await Future.delayed(const Duration(seconds: 3));
  }
});
