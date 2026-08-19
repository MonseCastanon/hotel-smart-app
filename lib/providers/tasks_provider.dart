import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_smart_app/config/services/hotel_service.dart';
import 'package:hotel_smart_app/models/task_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Providers de tareas
// ─────────────────────────────────────────────────────────────────────────────

/// Stream de tareas recientes (últimas 20), ordenadas por createdAt descendente.
/// Se actualiza en tiempo real cuando Hotel-Project o Wear modifican una tarea.
final recentTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final service = ref.watch(hotelServiceProvider);
  return service.watchRecentTasks(limit: 20).map(_snapshotToTasks);
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
