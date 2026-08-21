import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

/// Fuente de datos de tareas para el tablero Kanban.
///
/// Intenta conectar con Firestore en tiempo real. Si la colección está
/// vacía o Firebase no está disponible, provee datos dummy como fallback
/// para que la UI siempre tenga contenido visual.
class TasksDatasource {
  final FirebaseFirestore _firestore;

  TasksDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _tasks =>
      _firestore.collection('tasks');

  // ─────────────────────────────────────────────────────────────────────────
  // Streams en tiempo real (Firestore)
  // ─────────────────────────────────────────────────────────────────────────

  /// Stream de tareas pendientes desde Firestore.
  Stream<List<TaskModel>> watchPendingTasks() {
    return _tasks
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  /// Stream de tareas en progreso desde Firestore.
  /// Usa 'inProgress' (camelCase) para coincidir con WearTaskStatus.inProgress.name.
  Stream<List<TaskModel>> watchInProgressTasks() {
    return _tasks
        .where('status', isEqualTo: 'inProgress')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  /// Stream de todas las tareas activas (no completadas).
  /// Usa 'inProgress' (camelCase) para coincidir con WearTaskStatus.inProgress.name.
  Stream<List<TaskModel>> watchActiveTasks({int limit = 20}) {
    return _tasks
        .where('status', whereIn: ['pending', 'inProgress'])
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

}
