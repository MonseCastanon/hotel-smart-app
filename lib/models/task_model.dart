class TaskModel {
  final String id;
  final String serviceType;
  final String assignedTo;
  final String room;
  final String date;
  final String status;
  final String? guestName;
  final int priority;

  const TaskModel({
    this.id = '',
    required this.serviceType,
    required this.assignedTo,
    required this.room,
    required this.date,
    required this.status,
    this.guestName,
    this.priority = 3,
  });

  /// Crea un [TaskModel] desde un documento Firestore.
  /// Compatible con el esquema de [FirebaseTaskService] en Hotel-Project.
  factory TaskModel.fromFirestore(String docId, Map<String, dynamic> data) {
    final createdAt = _parseDate(data['createdAt']);
    final formattedDate = _formatDate(createdAt);

    final taskType = data['taskType'] as String? ?? 'cleaning';
    final serviceType = switch (taskType) {
      'cleaning' => 'Limpieza',
      'maintenance' => 'Mantenimiento',
      'inspection' => 'Inspección',
      'delivery' => 'Entrega',
      'guest_request' => 'Solicitud',
      _ => taskType,
    };

    final rawStatus = data['status'] as String? ?? 'pending';
    final status = switch (rawStatus) {
      'pending' => 'Pendiente',
      'inProgress' => 'En proceso',
      'completed' => 'Completado',
      'cancelled' => 'Cancelado',
      _ => rawStatus,
    };

    final roomNumber = data['roomNumber'] as int? ?? 0;

    return TaskModel(
      id: docId,
      serviceType: serviceType,
      assignedTo: data['assignedTo'] as String? ?? '—',
      room: roomNumber.toString(),
      date: formattedDate,
      status: status,
      guestName: data['guestName'] as String?,
      priority: (data['priority'] as num?)?.toInt() ?? 3,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  static String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);

    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    if (date == today) return 'Hoy, $hour:$minute';
    final diff = today.difference(date).inDays;
    if (diff == 1) return 'Ayer, $hour:$minute';
    return '${dt.day}/${dt.month}, $hour:$minute';
  }

  /// Retorna true si la tarea está activa (pendiente o en proceso)
  bool get isActive => status == 'Pendiente' || status == 'En proceso';
}
