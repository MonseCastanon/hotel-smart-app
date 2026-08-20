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
  Stream<List<TaskModel>> watchInProgressTasks() {
    return _tasks
        .where('status', isEqualTo: 'in_progress')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  /// Stream de todas las tareas activas (no completadas).
  Stream<List<TaskModel>> watchActiveTasks({int limit = 20}) {
    return _tasks
        .where('status', whereIn: ['pending', 'in_progress'])
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TaskModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Datos dummy (fallback cuando Firestore está vacío)
  // ─────────────────────────────────────────────────────────────────────────

  /// Tareas pendientes de ejemplo para visualización del tablero.
  static List<TaskModel> getDummyPendingTasks() {
    final now = DateTime.now();
    return [
      TaskModel(
        id: 'dummy-1',
        serviceType: 'Mantenimiento',
        assignedTo: 'Carlos R.',
        room: '302',
        status: 'pending',
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
      TaskModel(
        id: 'dummy-2',
        serviceType: 'Limpieza',
        assignedTo: 'Elena J.',
        room: '306',
        status: 'pending',
        createdAt: now.subtract(const Duration(hours: 1, minutes: 15)),
      ),
      TaskModel(
        id: 'dummy-3',
        serviceType: 'Room Service',
        assignedTo: 'Sin asignar',
        room: '508',
        status: 'pending',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      TaskModel(
        id: 'dummy-4',
        serviceType: 'Mantenimiento',
        assignedTo: 'Sin asignar',
        room: '201',
        status: 'pending',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
    ];
  }

  /// Tareas en progreso de ejemplo.
  static List<TaskModel> getDummyInProgressTasks() {
    final now = DateTime.now();
    return [
      TaskModel(
        id: 'dummy-5',
        serviceType: 'Limpieza',
        assignedTo: 'María G.',
        room: '801',
        status: 'in_progress',
        createdAt: now.subtract(const Duration(minutes: 45)),
      ),
      TaskModel(
        id: 'dummy-6',
        serviceType: 'Mantenimiento',
        assignedTo: 'Pedro S.',
        room: '411',
        status: 'in_progress',
        createdAt: now.subtract(const Duration(hours: 1, minutes: 30)),
      ),
      TaskModel(
        id: 'dummy-7',
        serviceType: 'Limpieza',
        assignedTo: 'María G.',
        room: '205',
        status: 'in_progress',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ];
  }
}
