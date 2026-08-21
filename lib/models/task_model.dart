/// Modelo de tarea para el tablero Kanban de la Smart TV.
///
/// Representa un documento de la colección `tasks` en Firestore.
/// Se excluyen tareas con status 'completed' del tablero.
class TaskModel {
  final String id;
  final String serviceType;
  final String assignedTo;
  final String room;
  final String status;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.serviceType,
    required this.assignedTo,
    required this.room,
    required this.status,
    required this.createdAt,
  });

  /// Crea un [TaskModel] a partir de un documento de Firestore.
  ///
  /// Compatible con el esquema de Hotel-Project:
  ///   • roomNumber → int  → se convierte con toString()
  ///   • assignedBy → campo real en Hotel-Project (assignedTo como alias)
  factory TaskModel.fromFirestore(
    String docId,
    Map<String, dynamic> data,
  ) {
    return TaskModel(
      id: docId,
      serviceType: data['serviceType'] as String? ?? data['taskType'] as String? ?? data['type'] as String? ?? 'Sin tipo',
      // Prioridad: assignedTo → assignedByName (nombre legible) → assignedBy (UID como último recurso)
      assignedTo: data['assignedTo'] as String?
          ?? data['assignedByName'] as String?
          ?? data['assignedBy'] as String?
          ?? 'Sin asignar',
      // roomNumber puede ser int o String según quién escribió el documento
      room: data['room'] as String? ?? data['roomNumber']?.toString() ?? '—',
      status: data['status'] as String? ?? 'pending',
      createdAt: _parseDate(data['createdAt'] ?? data['date']),
    );
  }

  /// Convierte el modelo a un mapa compatible con Firestore.
  Map<String, dynamic> toFirestore() => {
        'serviceType': serviceType,
        'assignedTo': assignedTo,
        'room': room,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Helper para parsear fechas de Firestore (Timestamp, String o null).
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    // Firestore Timestamp
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  /// Formato legible de la fecha para la UI.
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    return '${createdAt.day}/${createdAt.month} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  /// Etiqueta legible del estado.
  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En Progreso';
      case 'completed':
        return 'Completado';
      default:
        return status;
    }
  }
}
