import 'package:flutter/material.dart';
import '../data/notifications_datasource.dart';
import '../data/tasks_datasource.dart';
import '../widgets/notification_banner.dart';
import '../widgets/room_type_card.dart';
import '../widgets/activity_table.dart';
import '../config/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Simula la llegada de la notificación push flotante 1 segundo después de cargar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          final notifications = NotificationsDatasource().getActiveNotifications();
          if (notifications.isNotEmpty) {
            NotificationBanner.show(context, notifications.first);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Muestra únicamente las primeras 3 actividades recientes
    final tasks = TasksDatasource().getRecentActivity().take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: FocusTraversalGroup(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Top 60%: Actividad Reciente (colocada hasta arriba en el layout)
                    Expanded(
                      flex: 3,
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
                    
                    // Bottom 40%: Información de Habitaciones
                    Expanded(
                      flex: 2,
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
