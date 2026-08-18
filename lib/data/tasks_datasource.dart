import '../models/task_model.dart';

class TasksDatasource {
  List<TaskModel> getRecentActivity() {
    return [
      const TaskModel(
        serviceType: 'Limpieza',
        assignedTo: 'María G.',
        room: '801',
        date: 'Hoy, 10:30 AM',
        status: 'En proceso',
      ),
      const TaskModel(
        serviceType: 'Mantenimiento',
        assignedTo: 'Carlos R.',
        room: '302',
        date: 'Hoy, 10:00 AM',
        status: 'Pendiente',
      ),
      const TaskModel(
        serviceType: 'Room Service',
        assignedTo: 'Ana L.',
        room: '505',
        date: 'Hoy, 09:15 AM',
        status: 'Completado',
      ),
    ];
  }
}
