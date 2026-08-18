import '../models/notification_model.dart';

class NotificationsDatasource {
  List<NotificationModel> getActiveNotifications() {
    return [
      const NotificationModel(
        title: 'Se necesita limpieza',
        description: 'Limpieza solicitada por el huésped.',
        relatedRoom: 'Habitación 801',
        time: 'Ahora',
      ),
      const NotificationModel(
        title: 'Mantenimiento preventivo',
        description: 'Revisión de aire acondicionado.',
        relatedRoom: 'Habitación 302',
        time: '15 min.',
      ),
    ];
  }
}
