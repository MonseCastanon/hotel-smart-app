import 'package:flutter/material.dart';
import '../data/notifications_datasource.dart';
import '../data/tasks_datasource.dart';
import '../widgets/notification_banner.dart';
import '../widgets/room_type_card.dart';
import '../widgets/activity_table.dart';
import '../config/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationsDatasource().getActiveNotifications();
    final tasks = TasksDatasource().getRecentActivity();

    return Scaffold(
      body: SafeArea(
        child: FocusTraversalGroup(
          child: Column(
            children: [
              // 1. Notificaciones
              if (notifications.isNotEmpty)
                NotificationBanner(notification: notifications.first),
              
              Expanded(
                child: Column(
                  children: [
                    // Top 50%: Actividad Reciente
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Actividad Reciente',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 16),
                            Expanded(child: ActivityTable(tasks: tasks)),
                          ],
                        ),
                      ),
                    ),
                    
                    // Bottom 50%: Información de Habitaciones
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estado de Habitaciones',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RoomTypeCard(
                                      title: 'Ocupadas',
                                      count: 15,
                                      icon: Icons.hotel,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: RoomTypeCard(
                                      title: 'Por Entregar',
                                      count: 4,
                                      icon: Icons.cleaning_services,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: RoomTypeCard(
                                      title: 'Por Llegar',
                                      count: 7,
                                      icon: Icons.luggage,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
