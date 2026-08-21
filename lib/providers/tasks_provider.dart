import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_smart_app/config/services/hotel_service.dart';
import 'package:hotel_smart_app/models/task_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Providers de tareas
// ─────────────────────────────────────────────────────────────────────────────

/// Stream de tareas pendientes (`status == 'pending'`) para la columna Kanban.
/// Se actualiza en tiempo real cuando Hotel-Project crea nuevas tareas.
final pendingTasksStreamProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(hotelServiceProvider);
  return service.watchPendingTasks().map(_snapshotToTasks);
});

/// Stream de tareas en progreso (`status == 'inProgress'`) para la columna Kanban.
/// Se actualiza en tiempo real cuando hotel-wear-app acepta y trabaja una tarea.
/// Nota: usa 'inProgress' (camelCase) para coincidir con WearTaskStatus.inProgress.name.
final inProgressTasksStreamProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(hotelServiceProvider);
  return service.watchInProgressTasks().map(_snapshotToTasks);
});

/// Stream de tareas activas (pending + inProgress) para el dashboard.
/// Son las tareas que el wearable está procesando actualmente.
final activeTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(hotelServiceProvider);
  return service.watchActiveTasks().map(_snapshotToTasks);
});

/// Helper para convertir QuerySnapshot a `List<TaskModel>`.
List<TaskModel> _snapshotToTasks(
    QuerySnapshot<Map<String, dynamic>> snapshot) {
  return snapshot.docs
      .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
      .toList();
}
