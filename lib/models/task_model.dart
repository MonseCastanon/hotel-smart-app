class TaskModel {
  final String serviceType;
  final String assignedTo;
  final String room;
  final String date;
  final String status;

  const TaskModel({
    required this.serviceType,
    required this.assignedTo,
    required this.room,
    required this.date,
    required this.status,
  });
}
