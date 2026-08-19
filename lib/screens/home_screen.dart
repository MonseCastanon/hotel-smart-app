import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tasks_provider.dart';
import '../providers/rooms_provider.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notification_banner.dart';
import '../widgets/room_type_card.dart';
import '../widgets/activity_table.dart';
import '../config/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _notificationShown = false;

  @override
  void initState() {
    super.initState();
    // Muestra la primera notificación activa de Firestore cuando llegue
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleNotification();
    });
  }

  void _scheduleNotification() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted || _notificationShown) return;
      final notificationsAsync = ref.read(notificationsProvider);
      notificationsAsync.whenData((notifications) {
        if (notifications.isNotEmpty && mounted && !_notificationShown) {
          _notificationShown = true;
          NotificationBanner.show(context, notifications.first);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(recentTasksProvider);
    final statsAsync = ref.watch(roomStatsProvider);

    return Scaffold(
      body: SafeArea(
        child: FocusTraversalGroup(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Top 60%: Actividad Reciente desde Firestore
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Actividad Reciente',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(width: 12),
                                // Indicador de conexión en tiempo real
                                tasksAsync.when(
                                  data: (_) => _buildLiveDot(context),
                                  loading: () => const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                  error: (e, _) => const Icon(
                                      Icons.wifi_off,
                                      size: 16,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: tasksAsync.when(
                                data: (tasks) {
                                  if (tasks.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        'No hay actividad reciente',
                                        style:
                                            TextStyle(color: Colors.white54),
                                      ),
                                    );
                                  }
                                  return ActivityTable(
                                    tasks: tasks.take(5).toList(),
                                  );
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (e, _) => _buildErrorWidget(
                                    'Error cargando actividad'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom 40%: Estadísticas de Habitaciones desde Firestore
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estado de Habitaciones',
                              style:
                                  Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: statsAsync.when(
                                data: (stats) => Row(
                                  children: [
                                    Expanded(
                                      child: RoomTypeCard(
                                        title: 'Ocupadas',
                                        count: stats.occupied,
                                        icon: Icons.hotel,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: RoomTypeCard(
                                        title: 'Por Entregar',
                                        count: stats.needsAttention,
                                        icon: Icons.cleaning_services,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: RoomTypeCard(
                                        title: 'Disponibles',
                                        count: stats.available,
                                        icon: Icons.check_circle_outline,
                                        color: AppColors.success,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: RoomTypeCard(
                                        title: 'Reservadas',
                                        count: stats.reserved,
                                        icon: Icons.luggage,
                                        color: const Color(0xFF7C4DFF),
                                      ),
                                    ),
                                  ],
                                ),
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (e, _) => _buildErrorWidget(
                                    'Error cargando estadísticas'),
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

  Widget _buildLiveDot(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'En vivo',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 32, color: Colors.orange),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.orange, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
