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
      const TaskModel(
        serviceType: 'Limpieza',
        assignedTo: 'Sofía M.',
        room: '204',
        date: 'Hoy, 08:45 AM',
        status: 'Completado',
      ),
      const TaskModel(
        serviceType: 'Mantenimiento',
        assignedTo: 'Pedro S.',
        room: '411',
        date: 'Hoy, 08:30 AM',
        status: 'En proceso',
      ),
      const TaskModel(
        serviceType: 'Room Service',
        assignedTo: 'Luis P.',
        room: '102',
        date: 'Hoy, 08:15 AM',
        status: 'Completado',
      ),
      const TaskModel(
        serviceType: 'Limpieza',
        assignedTo: 'Elena J.',
        room: '306',
        date: 'Hoy, 07:45 AM',
        status: 'Pendiente',
      ),
    ];
  }
}
