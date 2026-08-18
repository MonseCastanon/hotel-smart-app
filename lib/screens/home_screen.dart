import 'package:flutter/material.dart';
import '../data/notifications_datasource.dart';
import '../data/tasks_datasource.dart';
import '../widgets/notification_banner.dart';
import '../widgets/room_type_card.dart';
import '../widgets/service_action_button.dart';
import '../widgets/activity_table.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationsDatasource().getActiveNotifications();
    final tasks = TasksDatasource().getRecentActivity();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: FocusTraversalGroup(
          child: Column(
            children: [
              // 1. Notificaciones
              if (notifications.isNotEmpty)
                NotificationBanner(notification: notifications.first),
              
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Izquierda: Habitaciones y Servicios
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 2. Habitaciones Disponibles
                            const Text(
                              'Habitaciones Disponibles',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              flex: 1,
                              child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 16.0,
                                crossAxisSpacing: 16.0,
                                children: const [
                                  RoomTypeCard(roomType: 'Estándar', availableCount: 12),
                                  RoomTypeCard(roomType: 'Doble', availableCount: 5),
                                  RoomTypeCard(roomType: 'Deluxe', availableCount: 2),
                                  RoomTypeCard(roomType: 'Suite', availableCount: 0),
                                ],
                              ),
                            ),
                            
                            // 3. Servicios
                            const SizedBox(height: 24),
                            const Text(
                              'Servicios',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ServiceActionButton(
                                      icon: Icons.login,
                                      title: 'Check-In',
                                      subtitle: 'Registrar llegada',
                                      isHighlighted: true,
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ServiceActionButton(
                                      icon: Icons.logout,
                                      title: 'Check-Out',
                                      subtitle: 'Registrar salida',
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ServiceActionButton(
                                      icon: Icons.receipt_long,
                                      title: 'Pagos',
                                      subtitle: 'Facturas',
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Derecha: Actividad Reciente
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Actividad Reciente',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Expanded(child: ActivityTable(tasks: tasks)),
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
